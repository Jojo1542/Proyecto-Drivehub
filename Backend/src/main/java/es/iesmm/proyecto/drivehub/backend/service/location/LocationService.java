package es.iesmm.proyecto.drivehub.backend.service.location;

import es.iesmm.proyecto.drivehub.backend.model.http.request.user.UserLocationUpdateRequest;
import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import es.iesmm.proyecto.drivehub.backend.model.user.location.UserLocation;

import java.util.Optional;

public interface LocationService {

    default void save(UserModel user, UserLocationUpdateRequest request) {
        save(user, UserLocation.from(request));
    }

    default void save(UserModel user, double latitude, double longitude) {
        save(user, UserLocation.from(latitude, longitude));
    }
    void save(UserModel user, UserLocation location);

    Optional<UserLocation> findLatestLocation(Long userId);

}
