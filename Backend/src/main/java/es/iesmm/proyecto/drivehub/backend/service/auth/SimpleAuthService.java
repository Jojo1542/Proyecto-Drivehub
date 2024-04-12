package es.iesmm.proyecto.drivehub.backend.service.auth;

import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.Date;
import java.util.concurrent.TimeUnit;
import java.util.logging.Logger;

import javax.crypto.SecretKey;

import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import es.iesmm.proyecto.drivehub.backend.repository.UserRepository;
import es.iesmm.proyecto.drivehub.backend.service.jwt.JwtService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DataAccessException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import jakarta.annotation.PostConstruct;

@Service
public class SimpleAuthService implements AuthService {

	@Autowired
	private UserRepository userRepository;

	@Autowired
	private PasswordEncoder passwordEncoder;

	@Autowired
	private JwtService jwtService;

	private final Logger logger = Logger.getLogger("AuthController");
	
	@Override
	public boolean registerUser(String email, String password, String firstName, String lastName) {
		boolean correct;
		
		try {
			userRepository.save(
					new UserModel(
							email, 
							passwordEncoder.encode(password), 
							firstName, 
							lastName
						)
				);
			logger.info("Registrado el usuario " + email);
			correct = true;
		} catch (DataAccessException e) {
			correct = false; // No se ha podido registrar el usuario ya que está duplicado
			logger.info("El usuario " + email + " está duplicado, no se registrará.");
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
			
			UserModel userModel = userRepository.getUserInfoByEmail(email);
			
			if (userModel != null) {
				if (passwordEncoder.matches(password, userModel.getPassword())) {
					token = jwtService.createToken(userModel);
				}
			}
		}
		
		return token;
	}
	
}
