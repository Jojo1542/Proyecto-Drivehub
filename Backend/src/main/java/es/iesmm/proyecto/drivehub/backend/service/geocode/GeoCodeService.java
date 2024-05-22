package es.iesmm.proyecto.drivehub.backend.service.geocode;

import es.iesmm.proyecto.drivehub.backend.util.distance.DistanceUnit;

public interface GeoCodeService {

    double calculateDistance(String origin, String destination, DistanceUnit unit);

    default double calculateDistance(String origin, String destination) {
        return calculateDistance(origin, destination, DistanceUnit.KILOMETERS);
    }

    default double calculateDistance(double originLatitude, double originLongitude, double destinationLatitude, double destinationLongitude, DistanceUnit unit) {
        return calculateDistance(
                getAddressFromCoordinates(originLatitude, originLongitude),
                getAddressFromCoordinates(destinationLatitude, destinationLongitude),
                unit
        );
    }

    default double calculateDistance(double originLatitude, double originLongitude, double destinationLatitude, double destinationLongitude) {
        return calculateDistance(
                originLatitude, originLongitude,
                destinationLatitude, destinationLongitude,
                DistanceUnit.KILOMETERS
        );
    }

    String getAddressFromCoordinates(double latitude, double longitude);

}
