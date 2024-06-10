package es.iesmm.proyecto.drivehub.backend.model.user.location;

import es.iesmm.proyecto.drivehub.backend.model.http.request.user.UserLocationUpdateRequest;

import java.util.Date;


public record UserLocation(double latitude, double longitude, Date updateTime) {
    public static UserLocation from(double latitude, double longitude) {
        return new UserLocation(latitude, longitude, new Date());
    }

    public static UserLocation from(UserLocationUpdateRequest request) {
        return from(request.latitude(), request.longitude());
    }
}
