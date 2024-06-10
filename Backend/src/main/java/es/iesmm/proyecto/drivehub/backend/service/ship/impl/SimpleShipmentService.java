package es.iesmm.proyecto.drivehub.backend.service.ship.impl;

import com.google.common.base.Preconditions;
import es.iesmm.proyecto.drivehub.backend.model.http.request.ship.ShipmentCreationRequest;
import es.iesmm.proyecto.drivehub.backend.model.http.request.ship.ShipmentStatusUpdateRequest;
import es.iesmm.proyecto.drivehub.backend.model.ship.Shipment;
import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import es.iesmm.proyecto.drivehub.backend.repository.ShipmentRepository;
import es.iesmm.proyecto.drivehub.backend.repository.UserRepository;
import es.iesmm.proyecto.drivehub.backend.service.ship.ShipmentService;
import es.iesmm.proyecto.drivehub.backend.service.user.UserService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@AllArgsConstructor
public class SimpleShipmentService implements ShipmentService {

    private final ShipmentRepository shipmentRepository;
    private final UserService userService;

    @Override
    public Optional<Shipment> findById(Long id) {
        return shipmentRepository.findById(id);
    }

    @Override
    public Shipment createShipment(ShipmentCreationRequest request) {
        // Control de errores y validaciones de los datos
        Preconditions.checkNotNull(request, "The request cannot be null");
        Preconditions.checkNotNull(request.sourceAddress(), "The source address cannot be null");
        Preconditions.checkNotNull(request.destinationAddress(), "The destination address cannot be null");
        Preconditions.checkNotNull(request.shipmentDate(), "The shipment date cannot be null");
        Preconditions.checkNotNull(request.deliveryDate(), "The delivery date cannot be null");
        Preconditions.checkNotNull(request.parcels(), "The parcels cannot be null");
        Preconditions.checkArgument(request.shipmentDate().before(request.deliveryDate()), "The shipment date must be before the delivery date");
        Preconditions.checkArgument(!request.parcels().isEmpty(), "The parcels cannot be empty");
        Preconditions.checkArgument(request.driverId() != null, "The driver id cannot be null");

        // Se convierte la petición en un envío y se guarda en la base de datos
        Shipment shipment = request.toShipment();

        shipment.setDriver(
                userService.findById(request.driverId())
                        .orElseThrow(() -> new IllegalArgumentException("The driver with id " + request.driverId() + " does not exist"))
        );

        shipment = shipmentRepository.save(shipment);

        return shipment;
    }

    @Override
    public Shipment updateStatus(Shipment shipment, ShipmentStatusUpdateRequest request) {
        // Control de errores y validaciones de los datos
        Preconditions.checkNotNull(shipment, "The shipment cannot be null");
        Preconditions.checkNotNull(request, "The request cannot be null");
        Preconditions.checkNotNull(request.status(), "The status cannot be null");

        // Se aplica la actualización del estado
        request.update(shipment);

        // Se guarda el envío en la base de datos
        shipment = shipmentRepository.save(shipment);

        return shipment;
    }

    @Override
    public void deleteById(Long id) {
        // Control de errores y validaciones de los datos
        Preconditions.checkNotNull(id, "The id cannot be null");
        Preconditions.checkArgument(shipmentRepository.existsById(id), "The shipment with id " + id + " does not exist");

        shipmentRepository.deleteById(id);
    }

    @Override
    public List<Shipment> findByDriver(UserModel user) {
        // Control de errores y validaciones de los datos
        Preconditions.checkNotNull(user, "The user cannot be null");

        return shipmentRepository.findByDriverId(user.getId());
    }

    @Override
    public Shipment save(Shipment shipment) {
        // Control de errores y validaciones de los datos
        Preconditions.checkNotNull(shipment, "The shipment cannot be null");
        Preconditions.checkNotNull(shipment.getId(), "The shipment id cannot be null");

        return shipmentRepository.save(shipment);
    }

    @Override
    public Shipment update(Shipment shipment, Shipment newDetails) {
        // Control de errores y validaciones de los datos
        Preconditions.checkNotNull(shipment, "The shipment cannot be null");
        Preconditions.checkNotNull(newDetails, "The new details cannot be null");
        Preconditions.checkArgument(newDetails.getId() != null && newDetails.getId().equals(shipment.getId()),
                "The id of the new details must be the same as the id of the shipment");

        // Se actualizan los detalles del envío
        shipment.setSourceAddress(newDetails.getSourceAddress());
        shipment.setDestinationAddress(newDetails.getDestinationAddress());
        shipment.setDeliveryDate(newDetails.getDeliveryDate());
        shipment.setParcels(newDetails.getParcels());

        // Se guarda el envío en la base de datos
        return shipmentRepository.save(shipment);
    }

}