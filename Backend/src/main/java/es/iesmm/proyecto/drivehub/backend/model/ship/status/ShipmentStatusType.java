package es.iesmm.proyecto.drivehub.backend.model.ship.status;

public enum ShipmentStatusType {

    HIDDEN, // Hidden status
    DELIVERED, // Already delivered
    PENDING_TO_PICK_UP, // Pending to pick up from the source address
    IN_TRANSIT, // In transit (from source to destination)
    PENDING_TO_DELIVER, // Pending to deliver to the destination address (Vamos en reparto)
    RETURNED, // Already returned to the source address
    CANCELED, // Canceled shipment
    LOST, // Lost shipment (Se ha caido del camion por el camino por ejemplo)
    DAMAGED, // Damaged shipment (Se ha roto por el camino)
    DELAYED, // Delayed shipment (Se ha retrasado)
    PENDING_TO_RETURN, // Pending to return to the source address

}
