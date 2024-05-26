package es.iesmm.proyecto.drivehub.backend.model.trip.status;

public record TripStatusUpdateMessage(long tripId, TripStatus status) {
}
