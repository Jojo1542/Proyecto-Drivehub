package es.iesmm.proyecto.drivehub.backend.service.location.impl;

import com.google.common.base.Preconditions;
import es.iesmm.proyecto.drivehub.backend.model.trip.location.TripLocationEmitterRow;
import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import es.iesmm.proyecto.drivehub.backend.model.user.location.UserLocation;
import es.iesmm.proyecto.drivehub.backend.service.location.LocationService;
import lombok.AllArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.util.*;
import java.util.concurrent.TimeUnit;

@Service
@AllArgsConstructor
public class RedisLocationService implements LocationService {

    private static final Logger log = LoggerFactory.getLogger(RedisLocationService.class);
    private final RedisTemplate<String, UserLocation> redisRepository;
    private final String KEY_PREFIX = "user:location:";

    private final Set<TripLocationEmitterRow> locationEmitters = new HashSet<>();

    @Override
    public void save(UserModel user, UserLocation location) {
        Preconditions.checkNotNull(user.getId(), "User must have an id");

        Date now = new Date();

        // Guardar en redis la localización del usuario por 4 días
        redisRepository.opsForValue().set(KEY_PREFIX + user.getId(), location, 4, TimeUnit.DAYS);

        // Actualizar la localización si hace falta en tiempo real y donde sea
        broadcastLocation(user.getId(), location);
    }

    @Override
    public Optional<UserLocation> findLatestLocation(Long userId) {
        Preconditions.checkNotNull(userId, "User id must not be null");

        return Optional.ofNullable(redisRepository.opsForValue().get(KEY_PREFIX + userId));
    }

    private void broadcastLocation(Long userId, UserLocation location) {
        locationEmitters.stream()
                .filter(emitter -> emitter.driverId().equals(userId))
                .forEach(emitter -> {
                    try {
                        emitter.emitter().send(location);
                    } catch (Exception e) {
                        emitter.emitter().completeWithError(e);
                        locationEmitters.remove(emitter);
                        log.error("Error sending location to emitter", e);
                    }
                });
    }

    private Optional<TripLocationEmitterRow> findEmitterByTrip(Long tripId) {
        return locationEmitters.stream()
                .filter(emitter -> emitter.tripId().equals(tripId))
                .findFirst();
    }

    private Optional<TripLocationEmitterRow> findEmitterByDriver(Long driverId) {
        return locationEmitters.stream()
                .filter(emitter -> emitter.driverId().equals(driverId))
                .findFirst();
    }

    @Override
    public void addLocationEmitter(Long driverId, Long tripId, SseEmitter emitter) {
        // Si ya existe un emisor para el trayecto, lo eliminamos
        findEmitterByTrip(tripId).ifPresent(oldData -> {
            oldData.emitter().complete();
            locationEmitters.remove(oldData);
        });

        // Añadimos el nuevo emisor
        locationEmitters.add(new TripLocationEmitterRow(tripId, driverId, emitter));
    }

    @Override
    public void removeLocationEmitter(Long tripId) {
        findEmitterByDriver(tripId).ifPresent(emitter -> {
            emitter.emitter().complete();
            locationEmitters.remove(emitter);
        });
    }

}
