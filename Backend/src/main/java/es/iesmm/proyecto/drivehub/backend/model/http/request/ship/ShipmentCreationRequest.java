package es.iesmm.proyecto.drivehub.backend.model.http.request.ship;

import es.iesmm.proyecto.drivehub.backend.model.ship.Shipment;
import es.iesmm.proyecto.drivehub.backend.model.ship.parcel.Parcel;

import java.sql.Date;
import java.util.List;

public record ShipmentCreationRequest(
        String sourceAddress,
        String destinationAddress,
        Date shipmentDate,
        Date deliveryDate,
        List<Parcel> parcels,
        Long driverId
) {

    public Shipment toShipment() {
        return Shipment.builder()
                .sourceAddress(sourceAddress)
                .destinationAddress(destinationAddress)
                .shipmentDate(shipmentDate)
                .deliveryDate(deliveryDate)
                .parcels(parcels)
                .build();
    }
}
