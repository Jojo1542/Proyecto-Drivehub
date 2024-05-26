package es.iesmm.proyecto.drivehub.backend.model.trip.location;

import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

public record TripLocationEmitterRow(Long tripId, Long driverId, SseEmitter emitter) implements AutoCloseable {
    @Override
    public void close() throws Exception {
        emitter.complete();
    }
}
