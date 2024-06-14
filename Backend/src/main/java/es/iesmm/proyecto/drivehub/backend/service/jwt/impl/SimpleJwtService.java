package es.iesmm.proyecto.drivehub.backend.service.jwt.impl;

import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import es.iesmm.proyecto.drivehub.backend.service.jwt.JwtService;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import jakarta.annotation.PostConstruct;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.util.Date;
import java.util.concurrent.TimeUnit;

@Service
public class SimpleJwtService implements JwtService {

    @Value("${jwt.secret}")
    private String jwtSecret;
    private SecretKey secretKey;

    // Cambiar a 1h de nuevo
    private final static long TIME_TO_EXPIRE = TimeUnit.HOURS.toMillis(24);

    @PostConstruct
    private void generateKey() {
        secretKey = Keys.hmacShaKeyFor(jwtSecret.getBytes());
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String createToken(UserModel userModel) {
        return Jwts.builder()
                .header().type("JWT") // Tipo de token JWT
                .and()
                .claim("userId", userModel.getId()) // ID del usuario
                .claim("email", userModel.getEmail()) // Email del usuario
                .issuedAt(new Date()) // Fecha de creación del token
                .expiration(new Date(System.currentTimeMillis() + TIME_TO_EXPIRE)) // 1 minuto de duración del token
                .signWith(secretKey, SignatureAlgorithm.HS512) // Firmar el token con la firma de la app
                .compact();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public boolean isValid(String token, UserModel userModel) {
        return !isExpired(token)
                && extractUserId(token).equals(userModel.getId())
                && extractEmail(token).equals(userModel.getEmail());
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String extractEmail(String token) {
        return extractClaims(token).get("email", String.class);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Long extractUserId(String token) {
        return extractClaims(token).get("userId", Long.class);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Date extractExpiration(String token) {
        return extractClaims(token).getExpiration();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public boolean isExpired(String token) {
        return extractExpiration(token).before(new Date());
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Claims extractClaims(String token) {
        return Jwts.parser()
                .setSigningKey(secretKey)
                .build()
                .parseClaimsJws(token)
                .getBody();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String refreshToken(String token) {
        return null;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public boolean canRefresh(String token) {
        return false;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String extractTokenFromHeader(String bearerToken) {
        String result = null;

        // Se obtiene el header de autorización y se separa el token del prefijo Bearer
        // El formato del token es: Bearer <token>
        if (bearerToken != null && bearerToken.startsWith("Bearer ")) {
            result = bearerToken.substring(7);
        }

        return result;
    }
}
