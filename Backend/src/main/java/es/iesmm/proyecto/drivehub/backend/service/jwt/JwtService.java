package es.iesmm.proyecto.drivehub.backend.service.jwt;

import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import io.jsonwebtoken.Claims;
import jakarta.servlet.http.HttpServletRequest;

import java.util.Date;

public interface JwtService {
    String createToken(UserModel userModel);

    boolean isValid(String token, UserModel userModel);

    String extractEmail(String token);

    Long extractUserId(String token);

    Date extractExpiration(String token);

    boolean isExpired(String token);

    Claims extractClaims(String token);

    String refreshToken(String token);

    boolean canRefresh(String token);

    String extractTokenFromHeader(String header);

    default String extractTokenFromRequest(HttpServletRequest request) {
        return extractTokenFromHeader(request.getHeader("Authorization"));
    }
}
