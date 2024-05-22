package es.iesmm.proyecto.drivehub.backend.service.geocode.impl;

import com.google.maps.DirectionsApi;
import com.google.maps.GeoApiContext;
import com.google.maps.GeocodingApi;
import com.google.maps.errors.ApiException;
import com.google.maps.model.DirectionsResult;
import com.google.maps.model.GeocodingResult;
import com.google.maps.model.LatLng;
import com.google.maps.model.TravelMode;
import es.iesmm.proyecto.drivehub.backend.service.geocode.GeoCodeService;
import es.iesmm.proyecto.drivehub.backend.util.distance.DistanceUnit;
import jakarta.annotation.PostConstruct;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.logging.Logger;

@Service
public class GoogleMapsGeoCodeService implements GeoCodeService {

    @Value("${google.api.key}")
    private String API_KEY;

    private GeoApiContext apiContext;
    private final Logger logger = Logger.getLogger("GoogleMapsGeoCodeService");

    @PostConstruct
    public void init() {
        apiContext = new GeoApiContext.Builder()
                .apiKey(API_KEY)
                .build();
    }

    @Override
    public double calculateDistance(String origin, String destination, DistanceUnit unit) {
        double distance = -1;

        // Controlar
        if (origin != null && destination != null) {
            try {
                // Obtenemos las direcciones según el origen y destino desde la API de Google Maps
                DirectionsResult result = DirectionsApi.getDirections(apiContext, origin, destination)
                        .mode(TravelMode.DRIVING)
                        .await();

                distance = result.routes[0].legs[0].distance.inMeters; // Obtenemos la distancia en metros
                distance = unit.fromMeters(distance); // Convertimos a la unidad deseada
            } catch (Exception e) {
                logger.severe("Error calculating distance between "
                        + origin + " and " + destination + ": " + e.getMessage());
            }
        }

        return distance;
    }

    @Override
    public String getAddressFromCoordinates(double latitude, double longitude) {
        String result = null;

        try {
            GeocodingResult[] geocodingResults = GeocodingApi.reverseGeocode(
                    apiContext, new LatLng(latitude, longitude)
            ).await();

            // Comprobar que hay resultados, y obtener la dirección
            if (geocodingResults != null && geocodingResults.length > 0) {
                result = geocodingResults[0].formattedAddress;
            }
        } catch (IOException | InterruptedException | ApiException e) {
            logger.severe("Error getting address from " + latitude + ", " + longitude + ": " + e.getMessage());
        }

        return result;
    }
}
