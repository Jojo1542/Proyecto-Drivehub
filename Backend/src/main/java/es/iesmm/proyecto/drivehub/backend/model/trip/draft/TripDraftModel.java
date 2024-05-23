package es.iesmm.proyecto.drivehub.backend.model.trip.draft;

import com.google.maps.model.LatLng;
import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Builder
public class TripDraftModel {

    private String id;
    private String origin;
    private String destination;

    private LatLng originCoordinates;
    private LatLng destinationCoordinates;

    private double price;
    private double distance;

}
