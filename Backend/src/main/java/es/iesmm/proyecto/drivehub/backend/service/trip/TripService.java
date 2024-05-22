package es.iesmm.proyecto.drivehub.backend.service.trip;

import es.iesmm.proyecto.drivehub.backend.model.trip.TripModel;
import es.iesmm.proyecto.drivehub.backend.model.trip.draft.TripDraftModel;
import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;

import java.util.List;
import java.util.Optional;

public interface TripService {

    TripDraftModel createDraft(UserModel user, String origin, String destination);

    Optional<TripDraftModel> getDraft(String draftId);

    void createTrip(UserModel user, TripDraftModel tripDraftModel);

    void assignDriver(UserModel driver, TripModel tripModel);

    void cancelTrip(TripModel tripModel);

    void finishTrip(TripModel tripModel);

    Optional<TripModel> findById(Long id);

    List<TripModel> findAll();

    List<TripModel> findByDriver(Long driverId);

    Optional<TripModel> findActiveByDriver(Long driverId);

    List<TripModel> findUserHistory(Long userId);

}
