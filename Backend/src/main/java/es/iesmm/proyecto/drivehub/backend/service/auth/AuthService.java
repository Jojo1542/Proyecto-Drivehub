package es.iesmm.proyecto.drivehub.backend.service.auth;

public interface AuthService {

	void registerUser(String email, String password, String firstName, String lastName);

	String loginUser(String header);
	
}
