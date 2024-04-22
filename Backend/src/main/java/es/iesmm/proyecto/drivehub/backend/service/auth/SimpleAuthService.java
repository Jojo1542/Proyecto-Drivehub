package es.iesmm.proyecto.drivehub.backend.service.auth;

import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import es.iesmm.proyecto.drivehub.backend.service.jwt.JwtService;
import es.iesmm.proyecto.drivehub.backend.service.user.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.logging.Logger;

@Service
public class SimpleAuthService implements AuthService {

    @Autowired
    private UserService userService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtService jwtService;

    private final Logger logger = Logger.getLogger("AuthController");

    @Override
    public boolean registerUser(String email, String password, String firstName, String lastName) {
        // Variable que indica si se ha registrado el usuario correctamente por defecto es false ya que no se ha registrado.
        // Si se registra correctamente se cambia a true.
        boolean correct = false;

        if (!userService.existsByEmail(email)) {
            try {
                // Se crea el usuario base con el constructor por defecto
                UserModel userModel = new UserModel(email, passwordEncoder.encode(password), firstName, lastName);

                // Se guarda el usuario en la base de datos
                userService.save(userModel);

                // Se avisa por consola de que se ha registrado el usuario para dejar constancia
                logger.info("Registrado el usuario " + email);
                correct = true; // Se ha registrado el usuario correctamente
            } catch (DataAccessException e) {
                // Si hay un error al guardar el usuario se avisa por consola
                logger.warning("Error al guardar el usuario " + email);
                logger.warning(e.getMessage());
            }
        }

        return correct;
    }

    @Override
    public String loginUser(String header) {
        String token = null;

        byte[] decodedHeader = Base64.getDecoder().decode(header);
        String rawHeader = new String(decodedHeader, StandardCharsets.UTF_8);
        String[] splittedHeader = rawHeader.split(":");

        if (splittedHeader.length == 2) {
            String email = splittedHeader[0];
            String password = splittedHeader[1];

            // Se comprueba si el usuario existe y si la contraseña es correcta, si lo es se crea el token, si no lo es se devuelve null.
            token = userService.findByEmail(email)
                    .filter(user -> passwordEncoder.matches(password, user.getPassword()))
                    .map(jwtService::createToken)
                    .orElse(null);
        }

        return token;
    }

}
