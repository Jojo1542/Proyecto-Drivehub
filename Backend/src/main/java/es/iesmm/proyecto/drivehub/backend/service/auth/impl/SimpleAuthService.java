package es.iesmm.proyecto.drivehub.backend.service.auth.impl;

import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import es.iesmm.proyecto.drivehub.backend.service.auth.AuthService;
import es.iesmm.proyecto.drivehub.backend.service.auth.exception.EmailAlreadyExistException;
import es.iesmm.proyecto.drivehub.backend.service.auth.exception.UnknownRegisterException;
import es.iesmm.proyecto.drivehub.backend.service.jwt.JwtService;
import es.iesmm.proyecto.drivehub.backend.service.user.UserService;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.logging.Logger;

@Service
@AllArgsConstructor
public class SimpleAuthService implements AuthService {

    private final UserService userService;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    private final Logger logger = Logger.getLogger("AuthController");

    @Override
    public void registerUser(String email, String password, String firstName, String lastName) {
        // Usar el correo en minuscúlas siempre (por si el usuario lo ha escrito en mayúsculas o mixto)
        email = email.toLowerCase();

        // Se comprueba si el email ya está en uso en la base de datos
        if (!userService.existsByEmail(email)) {
            try {
                // Se crea el usuario base con el constructor por defecto
                UserModel userModel = new UserModel(email, passwordEncoder.encode(password), firstName, lastName);

                // Se guarda el usuario en la base de datos
                userService.save(userModel);

                // Se avisa por consola de que se ha registrado el usuario para dejar constancia
                logger.info("Registrado el usuario " + email);
            } catch (DataAccessException e) {
                // Si hay un error al guardar el usuario se avisa por consola
                logger.warning("Error al guardar el usuario " + email);
                logger.warning(e.getMessage());

                // Se lanza una excepción para que el controlador la capture y devuelva un error 500
                throw new UnknownRegisterException("Error al guardar el usuario", e);
            }
        } else {
            // Si el email ya está en uso se lanza una excepción para que el controlador la capture y devuelva un error 409
            throw new EmailAlreadyExistException("El email ya está en uso");
        }
    }

    @Override
    public String loginUser(String header) {
        String token = null;

        // Se decodifica el header, el cual es un Header HTTP Basic, el cual contiene el email y la contraseña separados por ":"
        byte[] decodedHeader = Base64.getDecoder().decode(header);
        String rawHeader = new String(decodedHeader, StandardCharsets.UTF_8); // Se convierte el byte[] a String
        String[] splittedHeader = rawHeader.split(":"); // Se separa el email y la contraseña

        // Se comprueba si el header tiene el formato correcto (email:password)
        if (splittedHeader.length == 2) {
            // Se extraen el email y la contraseña
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
