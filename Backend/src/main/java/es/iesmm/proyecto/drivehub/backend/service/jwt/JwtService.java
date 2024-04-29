package es.iesmm.proyecto.drivehub.backend.service.jwt;

import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import io.jsonwebtoken.Claims;
import jakarta.servlet.http.HttpServletRequest;

import java.util.Date;

public interface JwtService {

    /**
     * Crea un token JWT para el usuario
     * @param userModel Usuario
     * @return Token JWT
     */
    String createToken(UserModel userModel);

    /**
     * Comprueba si el token es válido para el usuario
     * @param token Token
     * @param userModel Usuario
     * @return Si el token es válido
     */
    boolean isValid(String token, UserModel userModel);

    /**
     * Extrae el email del token
     * @param token Token
     * @return Email
     */
    String extractEmail(String token);

    /**
     * Extrae el ID del usuario del token
     * @param token Token
     * @return ID del usuario
     */
    Long extractUserId(String token);

    /**
     * Extrae la fecha de expiración del token
     * @param token Token
     * @return Fecha de expiración
     */
    Date extractExpiration(String token);

    /**
     * Comprueba si el token ha expirado
     * @param token Token
     * @return Si el token ha expirado
     */
    boolean isExpired(String token);

    /**
     * Extrae los claims del token
     * @param token Token
     * @return Claims
     */
    Claims extractClaims(String token);

    /**
     * Refresca el token
     * @param token Token
     * @return Nuevo token
     */
    String refreshToken(String token);

    /**
     * Comprueba si se puede refrescar el token
     * @param token Token
     * @return Si se puede refrescar el token
     */
    boolean canRefresh(String token);

    /**
     * Extrae el token de un header
     * @param header Header
     * @return Token
     */
    String extractTokenFromHeader(String header);

    /**
     * Extrae el token de una petición
     * @param request Petición
     * @return Token
     */
    default String extractTokenFromRequest(HttpServletRequest request) {
        return extractTokenFromHeader(request.getHeader("Authorization"));
    }
}
