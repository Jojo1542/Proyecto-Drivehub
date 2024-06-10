package es.iesmm.proyecto.drivehub.backend.service.trip;

import es.iesmm.proyecto.drivehub.backend.model.trip.TripModel;
import es.iesmm.proyecto.drivehub.backend.model.trip.draft.TripDraftModel;
import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.util.List;
import java.util.Optional;

public interface TripService {

    TripDraftModel createDraft(UserModel user, String origin, String destination);

    Optional<TripDraftModel> findDraft(String draftId);

    default void createTrip(UserModel user, TripDraftModel tripDraftModel) {
        createTrip(user, tripDraftModel, false);
    }

    TripModel createTrip(UserModel user, TripDraftModel tripDraftModel, boolean sendPackage);

    void assignDriver(UserModel driver, TripModel tripModel);

    void cancelTrip(TripModel tripModel);

    void finishTrip(TripModel tripModel);

    Optional<TripModel> findById(Long id);

    List<TripModel> findAll();

    List<TripModel> findActiveTrips();

    List<TripModel> findByDriver(Long driverId);

    Optional<TripModel> findActiveByDriver(Long driverId);

    List<TripModel> findUserHistory(Long userId);

    List<TripModel> findDriverHistory(Long id);

    Optional<TripModel> findActiveByPassenger(Long passengerId);

    SseEmitter streamTripStatus(TripModel tripModel);

    SseEmitter streamTripLocation(TripModel tripModel);

    SseEmitter streamDuty(UserModel userDetails);
}
