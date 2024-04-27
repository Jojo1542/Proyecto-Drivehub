package es.iesmm.proyecto.drivehub.backend;

import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import es.iesmm.proyecto.drivehub.backend.repository.UserRepository;
import es.iesmm.proyecto.drivehub.backend.service.user.UserService;
import io.micrometer.common.util.StringUtils;
import jakarta.annotation.PostConstruct;
import lombok.AllArgsConstructor;
import net.bytebuddy.utility.RandomString;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.util.logging.Logger;

@SpringBootApplication
@AllArgsConstructor
public class BackendApplication {

	private static final String DEFAULT_ADMIN_EMAIL = "admin@jojo1542.es";

	public static void main(String[] args) {
		SpringApplication.run(BackendApplication.class, args);
	}

	private final UserService userService;
	private final Logger logger = Logger.getLogger("Startup");

	/*
	 * Método que se ejecuta al iniciar la aplicación, se utiliza para generar una cuenta de administrador por defecto
	 * si es el primer inicio de la aplicación y no hay ningún usuario registrado.
	 */
	@PostConstruct
	public void checkSetup() {
		// Comprobar si no hay usuarios registrados, si no los hay, crear una cuenta de administrador por defecto
		if (userService.count() == 0) {
			String password = RandomString.make(10);

			// Crear la cuenta de administrador por defecto y persistirla
			userService.createDefaultUser(DEFAULT_ADMIN_EMAIL, password);

			// Mostrar los datos de la cuenta de administrador por defecto
			logger.info("----------------------------------------------------");
			logger.info("Parece ser que es la primera vez que inicias la aplicación, vamos a crear una cuenta de administrador por defecto.");
			logger.info("");
			logger.info("Email: " + DEFAULT_ADMIN_EMAIL);
			logger.info("Contraseña: " + password);
			logger.info("");
			logger.info("IMPORTANTE: Esta será la única vez que podrás ver estos datos, asegúrate de guardarlos en un lugar seguro.");
			logger.info("----------------------------------------------------");
		}
	}

}
