package es.iesmm.proyecto.drivehub.backend.service.jwt;

import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import io.jsonwebtoken.Claims;

import java.util.Date;

public interface JwtService {
    String createToken(UserModel userModel);

    boolean isValid(String token, UserModel userModel);

    String extractEmail(String token);

    Long extractUserId(String token);

    Date extractExpiration(String token);

    boolean isExpired(String token);

    Claims extractClaims(String token);
}
