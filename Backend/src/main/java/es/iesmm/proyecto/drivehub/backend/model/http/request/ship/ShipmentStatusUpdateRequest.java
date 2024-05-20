package es.iesmm.proyecto.drivehub.backend.model.http.request.ship;

import es.iesmm.proyecto.drivehub.backend.model.ship.Shipment;
import es.iesmm.proyecto.drivehub.backend.model.ship.status.ShipmentStatusType;
import es.iesmm.proyecto.drivehub.backend.model.ship.status.ShipmentStatusUpdate;

import java.sql.Date;

public record ShipmentStatusUpdateRequest(
        String description,
        ShipmentStatusType status
) {

    public Shipment update(Shipment shipment) {
        // Add the new status to the shipment
        shipment.getStatusHistory().add(ShipmentStatusUpdate.builder()
                .updateDate(new Date(System.currentTimeMillis()))
                .status(status)
                .description(description)
                .build());

        // Update the actual status
        shipment.setActualStatus(status);
        return shipment;
    }

}
