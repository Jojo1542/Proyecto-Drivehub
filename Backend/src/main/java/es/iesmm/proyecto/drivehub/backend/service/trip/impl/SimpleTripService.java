package es.iesmm.proyecto.drivehub.backend.service.trip.impl;

import com.google.common.base.Preconditions;
import es.iesmm.proyecto.drivehub.backend.model.trip.TripModel;
import es.iesmm.proyecto.drivehub.backend.model.trip.draft.TripDraftModel;
import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import es.iesmm.proyecto.drivehub.backend.service.geocode.GeoCodeService;
import es.iesmm.proyecto.drivehub.backend.service.trip.TripService;
import es.iesmm.proyecto.drivehub.backend.util.distance.DistanceUnit;
import lombok.AllArgsConstructor;
import net.bytebuddy.utility.RandomString;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.concurrent.TimeUnit;

@Service
@AllArgsConstructor
public class SimpleTripService implements TripService {

    private final String KEY_PREFIX = "trip:draft:";

    private final RedisTemplate<String, TripDraftModel> redisRepository;
    private final GeoCodeService geoCodeService;

    @Value("${price.per.km}")
    private final double PRICE_PER_KM = 0.5;

    @Override
    public TripDraftModel createDraft(UserModel user, String origin, String destination) {
        double distance = geoCodeService.calculateDistance(origin, destination, DistanceUnit.KILOMETERS);

        Preconditions.checkArgument(distance > 0, "INVALID_DISTANCE_BETWEEN");

        String randomId = RandomString.make(10);

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
    public void createTrip(UserModel user, TripDraftModel tripDraftModel) {

        // TODO: Avisar a los conductores más cercanos para que puedan aceptar el trayecto mediante el websocket
    }

    @Override
    public void assignDriver(UserModel driver, TripModel tripModel) {

        // TODO: Avisar al usuario de la actualización de su trayecto mediante el websocket
    }

    @Override
    public void cancelTrip(TripModel tripModel) {

        // TODO: Avisar al usuario de la cancelación de su trayecto mediante el websocket
    }

    @Override
    public void finishTrip(TripModel tripModel) {

        // TODO: Avisar al usuario de la cancelación de su trayecto mediante el websocket
    }

    @Override
    public Optional<TripModel> findById(Long id) {
        return Optional.empty();
    }

    @Override
    public List<TripModel> findAll() {
        return null;
    }

    @Override
    public List<TripModel> findByDriver(Long driverId) {
        return null;
    }

    @Override
    public Optional<TripModel> findActiveByDriver(Long driverId) {
        return Optional.empty();
    }

    @Override
    public List<TripModel> findUserHistory(Long userId) {
        return null;
    }
}
