package es.iesmm.proyecto.drivehub.backend.service.fleet;

import es.iesmm.proyecto.drivehub.backend.model.fleet.Fleet;
import es.iesmm.proyecto.drivehub.backend.model.http.request.fleet.FleetCreationRequest;
import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;

import java.util.List;
import java.util.Optional;

public interface FleetService {
    List<Fleet> findAll();

    Optional<Fleet> findById(Long fleetId);

    Optional<Fleet> findByDriver(UserModel userDetails);

    Fleet createFleet(UserModel userDetails, FleetCreationRequest request);

    Fleet updateById(Long fleetId, Fleet request);

    void deleteById(Long fleetId);

    List<Fleet> findByAdmin(UserModel user);
}
