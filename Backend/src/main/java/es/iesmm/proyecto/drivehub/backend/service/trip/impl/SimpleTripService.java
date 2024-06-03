package es.iesmm.proyecto.drivehub.backend.service.trip.impl;

import com.google.common.base.Preconditions;
import com.google.common.collect.MapMaker;
import es.iesmm.proyecto.drivehub.backend.model.trip.TripModel;
import es.iesmm.proyecto.drivehub.backend.model.trip.draft.TripDraftModel;
import es.iesmm.proyecto.drivehub.backend.model.trip.status.TripStatus;
import es.iesmm.proyecto.drivehub.backend.model.trip.status.TripStatusUpdateMessage;
import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.chauffeur.ChauffeurDriverModelData;
import es.iesmm.proyecto.drivehub.backend.model.user.location.UserLocation;
import es.iesmm.proyecto.drivehub.backend.repository.TripRepository;
import es.iesmm.proyecto.drivehub.backend.repository.UserRepository;
import es.iesmm.proyecto.drivehub.backend.service.geocode.GeoCodeService;
import es.iesmm.proyecto.drivehub.backend.service.location.LocationService;
import es.iesmm.proyecto.drivehub.backend.service.trip.TripService;
import es.iesmm.proyecto.drivehub.backend.util.distance.DistanceUnit;
import lombok.AllArgsConstructor;
import net.bytebuddy.utility.RandomString;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

@Service
@AllArgsConstructor
public class SimpleTripService implements TripService {

    private static final Logger log = LoggerFactory.getLogger(SimpleTripService.class);
    private final String KEY_PREFIX = "trip:draft:";

    private final RedisTemplate<String, TripDraftModel> redisRepository;
    private final GeoCodeService geoCodeService;
    private final UserRepository userRepository;
    private final LocationService locationService;

    @Value("${price.per.km}")
    private final double PRICE_PER_KM = 1.5;
    private final TripRepository tripRepository;

    private final Map<Long, SseEmitter> tripStatusEmitters = new MapMaker().makeMap();
    private final Map<Long, SseEmitter> dutyEmitters = new ConcurrentHashMap<>();

    private final ExecutorService executorService = Executors.newCachedThreadPool();

    @Override
    public TripDraftModel createDraft(UserModel user, String origin, String destination) {
        double distance = geoCodeService.calculateDistance(origin, destination, DistanceUnit.KILOMETERS);

        Preconditions.checkArgument(distance > 0, "INVALID_DISTANCE_BETWEEN");

        String randomId = RandomString.make(10);

        double price = distance * PRICE_PER_KM;
        double roundedPrice = Math.round(price * 100.0) / 100.0;

        // Creamos el borrador del trayecto con los datos proporcionados
        TripDraftModel tripDraft = TripDraftModel.builder()
                .id(randomId)
                .origin(origin)
                .destination(destination)
                .distance(distance)
                .destinationCoordinates(geoCodeService.getCoordinatesFromAddress(destination))
                .originCoordinates(geoCodeService.getCoordinatesFromAddress(origin))
                .price(roundedPrice)
                .build();

        // Guardar en redis el borrador del trayecto por 10 minutos para que el usuario pueda completar la compra
        redisRepository.opsForValue().set(KEY_PREFIX + tripDraft.getId(), tripDraft, 10, TimeUnit.MINUTES);

        // Devolver el borrador del trayecto
        return tripDraft;
    }

    @Override
    public Optional<TripDraftModel> findDraft(String draftId) {
        return Optional.ofNullable(redisRepository.opsForValue().get(KEY_PREFIX + draftId));
    }

    /*
     * TODO: Implement the following methods:
     */

    @Override
    public TripModel createTrip(UserModel user, TripDraftModel tripDraftModel, boolean sendPackage) {
        Preconditions.checkArgument(tripDraftModel.getDistance() > 0, "INVALID_DISTANCE_BETWEEN");
        Preconditions.checkArgument(tripDraftModel.getPrice() > 0, "INVALID_PRICE");
        Preconditions.checkState(user.canAfford(tripDraftModel.getPrice()), "INSUFFICIENT_FUNDS");
        Preconditions.checkState(findActiveByPassenger(user.getId()).isEmpty(), "ACTIVE_TRIP_EXISTS");

        // Convertir las coordenadas a String
        String originCoordinates = tripDraftModel.getOriginCoordinates().lat + ";" + tripDraftModel.getOriginCoordinates().lng;
        String destinationCoordinates = tripDraftModel.getDestinationCoordinates().lat + ";" + tripDraftModel.getDestinationCoordinates().lng;

        // Crear el trayecto con el estado PENDING y los datos del borrador
        TripModel trip = TripModel.builder()
                .status(TripStatus.PENDING)
                .date(new Date())
                .startTime(new Date())
                .origin(originCoordinates)
                .destination(destinationCoordinates)
                .originAddress(tripDraftModel.getOrigin())
                .destinationAddress(tripDraftModel.getDestination())
                .price(tripDraftModel.getPrice())
                .distance(tripDraftModel.getDistance())
                .sendPackage(sendPackage)
                .passenger(user)
                .build();

        // Cobrar al usuario el precio del trayecto
        user.withdraw(tripDraftModel.getPrice());

        // Actualizar el usuario para guardar su saldo y guardar el trayecto
        userRepository.save(user);
        TripModel savedTrip = tripRepository.save(trip);

        // Se busca a un conductor en otro hilo para no retrasar la respuesta, se le pasa el trayecto
        executorService.execute(() -> findDriverToAssign(savedTrip));

        return savedTrip;
    }

    @Override
    public void assignDriver(UserModel driver, TripModel tripModel) {
        Preconditions.checkState(tripModel.getStatus() == TripStatus.PENDING, "TRIP_NOT_PENDING");
        Preconditions.checkState(tripModel.getDriver() == null, "TRIP_ALREADY_ASSIGNED");
        Preconditions.checkState(findActiveByDriver(driver.getId()).isEmpty(), "DRIVER_HAS_ACTIVE_TRIP");
        Preconditions.checkState(findActiveByPassenger(driver.getId()).isEmpty(), "DRIVER_IS_IN_TRIP");

        // Establecer el conductor, el modelo del vehículo y la matrícula del vehículo, también establecer el estado en ACEPTADO
        tripModel.setDriver(driver);
        tripModel.setStatus(TripStatus.ACCEPTED);

        // Obtener los datos del conductor para establecer el modelo y la matrícula del vehículo
        ChauffeurDriverModelData driverData = (ChauffeurDriverModelData) driver.getDriverData();
        tripModel.setVehicleModel(driverData.getVehicleModel());
        tripModel.setVehiclePlate(driverData.getVehiclePlate());
        tripModel.setVehicleColor(driverData.getVehicleColor());

        // Guardar el trayecto actualizado
        tripRepository.save(tripModel);

        // Avisar por el emitter de que el trayecto ha sido aceptado
        broadcastTripStatus(tripModel);
    }

    @Override
    public void cancelTrip(TripModel tripModel) {
        Preconditions.checkState(tripModel.isActive(), "TRIP_NOT_ACTIVE");

        // Cancelar el trayecto y devolver el saldo al usuario
        tripModel.setStatus(TripStatus.CANCELLED);
        tripModel.getPassenger().deposit(tripModel.getPrice());

        // Guardar el trayecto actualizado y el usuario actualizado
        tripRepository.save(tripModel);
        userRepository.saveAndFlush(tripModel.getPassenger()); // Guardar y forzar la actualización del usuario

        broadcastTripStatus(tripModel);
        if (tripModel.getDriver() != null) {
            Optional.ofNullable(dutyEmitters.get(tripModel.getDriver().getId())).ifPresent(SseEmitter::complete);
        }
    }

    @Override
    public void finishTrip(TripModel tripModel) {
        Preconditions.checkState(tripModel.getStatus() == TripStatus.ACCEPTED, "TRIP_NOT_ACCEPTED");

        // Finalizar el trayecto
        tripModel.setStatus(TripStatus.FINISHED);
        tripModel.setEndTime(new Date());

        // Guardar el trayecto actualizado
        tripRepository.save(tripModel);

        // Avisar por el emitter de la localización del conductor que el trayecto ha finalizado
        locationService.removeLocationEmitter(tripModel.getId());
        broadcastTripStatus(tripModel);
        Optional.ofNullable(dutyEmitters.get(tripModel.getDriver().getId())).ifPresent(SseEmitter::complete);
    }

    @Override
    public Optional<TripModel> findById(Long id) {
        return tripRepository.findById(id);
    }

    @Override
    public List<TripModel> findAll() {
        return tripRepository.findAll();
    }

    @Override
    public List<TripModel> findActiveTrips() {
        return tripRepository.findActiveTrips();
    }

    @Override
    public List<TripModel> findByDriver(Long driverId) {
        return tripRepository.findByDriverId(driverId);
    }

    @Override
    public Optional<TripModel> findActiveByDriver(Long driverId) {
        return tripRepository.findActiveByDriverId(driverId);
    }

    @Override
    public List<TripModel> findUserHistory(Long userId) {
        return tripRepository.findByPassengerId(userId);
    }

    @Override
    public List<TripModel> findDriverHistory(Long id) {
        return tripRepository.findByDriverId(id);
    }

    @Override
    public Optional<TripModel> findActiveByPassenger(Long passengerId) {
        return tripRepository.findActiveByPassengerId(passengerId);
    }

    private void broadcastTripStatus(TripModel tripModel) {
        if (tripStatusEmitters.containsKey(tripModel.getId())) {
            SseEmitter emitter = tripStatusEmitters.get(tripModel.getId());

            try {
                //noinspection DataFlowIssue
                log.info("Sending trip status update for trip {}", tripModel.getId());
                emitter.send(new TripStatusUpdateMessage(tripModel.getId(), tripModel.getStatus()));
            } catch (Exception e) {
                emitter.complete();
                tripStatusEmitters.remove(tripModel.getId());
            }
        }
    }

    private void findDriverToAssign(TripModel tripModel) {
        Preconditions.checkState(tripModel.getStatus() == TripStatus.PENDING, "TRIP_NOT_PENDING");
        Preconditions.checkState(tripModel.getDriver() == null, "TRIP_ALREADY_ASSIGNED");
        Preconditions.checkState(tripModel.getId() != null, "TRIP_NOT_SAVED");

        // Espera 5 segundos por si el usuario cancela el trayecto o simplemente para que inicie la conexión al emisor
        try {
            Thread.sleep(TimeUnit.SECONDS.toMillis(5));
        } catch (InterruptedException e) {
            log.error("Error while waiting for driver to accept the trip", e);
        }

        // Comprobar si el trayecto ha sido cancelado en esos segundos
        if (findById(tripModel.getId()).map(TripModel::getStatus).orElse(null) != TripStatus.PENDING) {
            log.info("Trip {} was cancelled while waiting for a driver", tripModel.getId());
            return;
        }

        // Obtener los conductores en duty
        Queue<UserModel> drivers = dutyEmitters.keySet().stream()
                // Obtener los conductores por ID y filtra que existan
                .map(userRepository::findById)
                .filter(Optional::isPresent)
                .map(Optional::get)
                // Filtrar por los conductores que no tienen un trayecto activo
                .filter(driver -> findActiveByDriver(driver.getId()).isEmpty())
                // Calcula la distancia de cada conductor al origen del trayecto y los mete en un mapa <Conductor, Distancia>
                .map(driver -> new AbstractMap.SimpleEntry<>(driver, calculateDistanceToOrigin(driver, tripModel)))
                // Filtra los conductores que no tienen una distancia valida o que no esten dentro de su rango de preferencia
                .filter(entry -> entry.getValue() < Double.MAX_VALUE)
                // Ordena por la distancia
                .sorted(Comparator.comparingDouble(AbstractMap.SimpleEntry::getValue))
                // Devuelve solo los conductores, no necesito la distancia
                .map(Map.Entry::getKey)
                // Los mete dentro de un linked list para poder hacer un poll
                .collect(Collectors.toCollection(LinkedList::new));

        // Hace la oferta a los conductores mas cercanos en orden, se hace la oferta, pero se espera 30 segundos a que acepten,
        // si no se acepta se sigue con el siguiente
        boolean driverAssigned = false;

        while (!drivers.isEmpty() && !driverAssigned) {
            UserModel driver = drivers.poll();

            SseEmitter emitter = dutyEmitters.get(driver.getId());

            // Si el conductor no tiene un emisor, se salta al siguiente ya que posiblemente se ya no esté en servicio
            if (emitter != null) {
                try {
                    emitter.send(tripModel);
                } catch (Exception e) {
                    emitter.complete();
                    dutyEmitters.remove(driver.getId());
                }

                try {
                    // Esperar 30 segundos a que el conductor acepte el trayecto
                    //noinspection BusyWait
                    Thread.sleep(TimeUnit.SECONDS.toMillis(30));
                } catch (InterruptedException e) {
                    log.error("Error while waiting for driver to accept the trip", e);
                }

                TripStatus status = tripRepository.findById(tripModel.getId()).map(TripModel::getStatus).orElse(null);

                if (status != TripStatus.PENDING) {
                    driverAssigned = true;
                }
            }
        }

        if (!driverAssigned) {
            // Cambiamos el estado del trayecto a CANCELADO por no tener conductor
            // y avisamos al emisor del estado del trayecto
            tripModel.setStatus(TripStatus.CANCELLED_DUE_TO_NO_DRIVER);
            broadcastTripStatus(tripModel);

            // Lo guardamos como cancelado
            tripModel.setStatus(TripStatus.CANCELLED);
            tripRepository.save(tripModel);

            // Añadir al usuario el saldo del trayecto
            tripModel.getPassenger().deposit(tripModel.getPrice());
            userRepository.save(tripModel.getPassenger());

            log.info("Trip {} was cancelled due to no driver available", tripModel.getId());
            Optional.ofNullable(tripStatusEmitters.get(tripModel.getId())).ifPresent(SseEmitter::complete);
        }
    }

    @Override
    public SseEmitter streamTripStatus(TripModel tripModel) {
        // Se crea el emitter y se le asigna un tiempo de vida de 30 minutos (Si dura mas, el cliente deberá reconectar)
        SseEmitter emitter = new SseEmitter(TimeUnit.MINUTES.toMillis(30));

        emitter.onTimeout(() -> tripStatusEmitters.remove(tripModel.getId()));
        emitter.onCompletion(() -> tripStatusEmitters.remove(tripModel.getId()));
        emitter.onError((e) -> {
            log.error("Error while streaming trip status", e);
            tripStatusEmitters.remove(tripModel.getId());
        });

        // Si ya existe un emisor para el trayecto, lo eliminamos y lo reemplazamos
        if (tripStatusEmitters.containsKey(tripModel.getId())) {
            tripStatusEmitters.get(tripModel.getId()).complete();
        }

        tripStatusEmitters.put(tripModel.getId(), emitter);

        // Envia un mensaje con la información del estado actual del trayecto
        try {
            //noinspection DataFlowIssue
            emitter.send(new TripStatusUpdateMessage(tripModel.getId(), tripModel.getStatus()));
        } catch (Exception e) {
            emitter.complete();
            tripStatusEmitters.remove(tripModel.getId());
        }

        return emitter;
    }

    @Override
    public SseEmitter streamTripLocation(TripModel tripModel) {
        // Se crea el emitter y se le asigna un tiempo de vida de 30 minutos (Si dura mas, el cliente deberá reconectar)
        SseEmitter emitter = new SseEmitter(TimeUnit.MINUTES.toMillis(30));

        emitter.onCompletion(() -> locationService.removeLocationEmitter(tripModel.getId()));
        emitter.onTimeout(() -> locationService.removeLocationEmitter(tripModel.getId()));
        emitter.onError((e) -> {
            log.error("Error while streaming trip location", e);
            tripStatusEmitters.remove(tripModel.getId());
        });

        System.out.println("Adding location emitter for trip " + tripModel.getId());
        locationService.addLocationEmitter(tripModel.getDriver().getId(), tripModel.getId(), emitter);
        return emitter;
    }

    @Override
    public SseEmitter streamDuty(UserModel userDetails) {
        // Se crea el emitter y se le asigna un tiempo de vida de 8 horas (Si dura mas, el cliente deberá reconectar)
        // (No creo que dure jaja)
        SseEmitter emitter = new SseEmitter(TimeUnit.HOURS.toMillis(8));

        emitter.onTimeout(() -> dutyEmitters.remove(userDetails.getId()));
        emitter.onCompletion(() -> dutyEmitters.remove(userDetails.getId()));
        emitter.onError((e) -> {
            tripStatusEmitters.remove(userDetails.getId());
        });

        // Si ya existe un emisor para el usuario, lo eliminamos y lo reemplazamos
        if (dutyEmitters.containsKey(userDetails.getId())) {
            dutyEmitters.get(userDetails.getId()).complete();
        }

        dutyEmitters.put(userDetails.getId(), emitter);

        return emitter;
    }

    private double calculateDistanceToOrigin(UserModel driver, TripModel tripModel) {
        Optional<UserLocation> driverLocation = locationService.findLatestLocation(driver.getId());

        double distance = Double.MAX_VALUE;

        if (driverLocation.isPresent()) {
            String driverAddress = geoCodeService.getAddressFromCoordinates(
                    driverLocation.get().latitude(),
                    driverLocation.get().longitude()
            );

            distance = geoCodeService.calculateDistance(driverAddress, tripModel.getOriginAddress(), DistanceUnit.KILOMETERS);

            ChauffeurDriverModelData driverData = (ChauffeurDriverModelData) driver.getDriverData();

            if (distance > driverData.getPreferedDistance()) {
                distance = Double.MAX_VALUE;
            }
        }

        return distance;
    }

    // Enviar un evento de keepalive a los emisores cada 10 segundos
    @Scheduled(fixedRate = 10_000)
    public void sendKeepAliveToEmitters() {
        tripStatusEmitters.forEach((id, emitter) -> {
            try {
                // Enviar un evento de keepalive para mantener la conexión abierta
                emitter.send(SseEmitter.event().name("keep-alive").data("keepalive"));
            } catch (Exception e) {
                emitter.complete();
                tripStatusEmitters.remove(id);
                log.error("Error sending keepalive to trip emitter", e);
            }
        });

        dutyEmitters.forEach((id, emitter) -> {
            try {
                // Enviar un evento de keepalive para mantener la conexión abierta
                emitter.send(SseEmitter.event().name("keep-alive").data("keepalive"));
            } catch (Exception e) {
                emitter.complete();
                dutyEmitters.remove(id);
            }
        });
    }
}
