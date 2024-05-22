package es.iesmm.proyecto.drivehub.backend.model.trip.draft;

import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Builder
public class TripDraftModel {

    private String id;
    private String origin;
    private String destination;
    private double price;
    private double distance;
    private boolean sendPackage;

}
