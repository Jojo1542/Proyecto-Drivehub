package es.iesmm.proyecto.drivehub.backend.service.ship;

import es.iesmm.proyecto.drivehub.backend.model.http.request.ship.ShipmentCreationRequest;
import es.iesmm.proyecto.drivehub.backend.model.http.request.ship.ShipmentStatusUpdateRequest;
import es.iesmm.proyecto.drivehub.backend.model.ship.Shipment;
import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import org.springframework.http.ProblemDetail;

import java.util.List;
import java.util.Optional;

public interface ShipmentService {
    Optional<Shipment> findById(Long id);

    Shipment createShipment(ShipmentCreationRequest request);

    Shipment updateStatus(Shipment shipment, ShipmentStatusUpdateRequest request);

    void deleteById(Long id);

    List<Shipment> findByDriver(UserModel user);

    List<Shipment> findByFleet(Long fleetId);

    Shipment save(Shipment shipment);

    Shipment update(Shipment shipment, Shipment newDetails);

    List<Shipment> findAll();

}
