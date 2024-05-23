package es.iesmm.proyecto.drivehub.backend.service.trip.impl;

import com.google.common.base.Preconditions;
import es.iesmm.proyecto.drivehub.backend.model.trip.TripModel;
import es.iesmm.proyecto.drivehub.backend.model.trip.draft.TripDraftModel;
import es.iesmm.proyecto.drivehub.backend.model.trip.status.TripStatus;
import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.chauffeur.ChauffeurDriverModelData;
import es.iesmm.proyecto.drivehub.backend.repository.TripRepository;
import es.iesmm.proyecto.drivehub.backend.repository.UserRepository;
import es.iesmm.proyecto.drivehub.backend.service.geocode.GeoCodeService;
import es.iesmm.proyecto.drivehub.backend.service.trip.TripService;
import es.iesmm.proyecto.drivehub.backend.util.distance.DistanceUnit;
import lombok.AllArgsConstructor;
import net.bytebuddy.utility.RandomString;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.TimeUnit;

@Service
@AllArgsConstructor
public class SimpleTripService implements TripService {

    private final String KEY_PREFIX = "trip:draft:";

    private final RedisTemplate<String, TripDraftModel> redisRepository;
    private final GeoCodeService geoCodeService;
    private final UserRepository userRepository;

    @Value("${price.per.km}")
    private final double PRICE_PER_KM = 0.5;
    private final TripRepository tripRepository;


    @Override
    public TripDraftModel createDraft(UserModel user, String origin, String destination) {
        double distance = geoCodeService.calculateDistance(origin, destination, DistanceUnit.KILOMETERS);

        Preconditions.checkArgument(distance > 0, "INVALID_DISTANCE_BETWEEN");

        String randomId = RandomString.make(10);

        // Creamos el borrador del trayecto con los datos proporcionados
        TripDraftModel tripDraft = TripDraftModel.builder()
                .id(randomId)
                .origin(origin)
                .destination(destination)
                .distance(distance)
                .price(distance * PRICE_PER_KM)
                .build();

        // Guardar en redis el borrador del trayecto por 10 minutos para que el usuario pueda completar la compra
        redisRepository.opsForValue().set(KEY_PREFIX + tripDraft.getId(), tripDraft, 10, TimeUnit.MINUTES);

        // Devolver el borrador del trayecto
        return tripDraft;
    }

    @Override
    public Optional<TripDraftModel> getDraft(String draftId) {
        return Optional.ofNullable(redisRepository.opsForValue().get(KEY_PREFIX + draftId));
    }

    /*
     * TODO: Implement the following methods:
     */

    @Override
    public void createTrip(UserModel user, TripDraftModel tripDraftModel, boolean sendPackage) {
        Preconditions.checkState(user.canAfford(tripDraftModel.getPrice()), "INSUFFICIENT_FUNDS");
        Preconditions.checkState(tripDraftModel.getDistance() > 0, "INVALID_DISTANCE_BETWEEN");
        Preconditions.checkState(tripDraftModel.getPrice() > 0, "INVALID_PRICE");
        Preconditions.checkState(findActiveByPassenger(user.getId()).isEmpty(), "ACTIVE_TRIP_EXISTS");

        // Crear el trayecto con el estado PENDING y los datos del borrador
        TripModel trip = TripModel.builder()
                .status(TripStatus.PENDING)
                .date(new Date())
                .startTime(new Date())
                .origin(tripDraftModel.getOrigin())
                .destination(tripDraftModel.getDestination())
                .price(tripDraftModel.getPrice())
                .distance(tripDraftModel.getDistance())
                .sendPackage(sendPackage)
                .passenger(user)
                .build();

        // Cobrar al usuario el precio del trayecto
        user.withdraw(tripDraftModel.getPrice());

        // Actualizar el usuario para guardar su saldo y guardar el trayecto
        userRepository.save(user);
        tripRepository.save(trip);


        // TODO: Avisar a los conductores más cercanos para que puedan aceptar el trayecto mediante el websocket
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

        // TODO: Avisar al usuario de la actualización de su trayecto mediante el websocket
        // A la hora de buscar conductores, avisar solo a los que tengan una preferencia de KM de distancia menor o igual a la distancia del trayecto
    }

    @Override
    public void cancelTrip(TripModel tripModel) {
        Preconditions.checkState(tripModel.isActive(), "TRIP_NOT_ACTIVE");

        // Cancelar el trayecto y devolver el saldo al usuario
        tripModel.setStatus(TripStatus.CANCELLED);
        tripModel.getPassenger().charge(tripModel.getPrice());

        // Guardar el trayecto actualizado y el usuario actualizado
        tripRepository.save(tripModel);
        userRepository.save(tripModel.getPassenger());

        // TODO: Avisar al usuario de la cancelación de su trayecto mediante el websocket
    }

    @Override
    public void finishTrip(TripModel tripModel) {
        Preconditions.checkState(tripModel.getStatus() == TripStatus.ACCEPTED, "TRIP_NOT_ACCEPTED");

        // Finalizar el trayecto
        tripModel.setStatus(TripStatus.FINISHED);

        // Guardar el trayecto actualizado
        tripRepository.save(tripModel);

        // TODO: Avisar al usuario de la cancelación de su trayecto mediante el websocket
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
    public Optional<TripModel> findActiveByPassenger(Long passengerId) {
        return tripRepository.findActiveByPassengerId(passengerId);
    }
}
