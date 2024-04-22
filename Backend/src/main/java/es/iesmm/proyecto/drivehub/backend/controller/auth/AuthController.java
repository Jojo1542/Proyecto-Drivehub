package es.iesmm.proyecto.drivehub.backend.controller.auth;

import es.iesmm.proyecto.drivehub.backend.model.response.auth.AuthenticationResponse;
import es.iesmm.proyecto.drivehub.backend.service.auth.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/auth")
public class AuthController {

	@Autowired
	private AuthService authService;

	/**
	 * Método HTTP /auth/register (POST) para registrar a un usuario.
	 *
	 * El método recibe los parámetros email, password, firstName y lastName. Si el email no está en uso, el método
	 * registra al usuario y devuelve un código de estado 201 (Created). En caso contrario, devuelve un código de estado
	 * 409 (Conflict).
	 *
	 * @return 201 Created si el usuario se ha registrado correctamente.
	 * @see "409 Conflict si el email ya está en uso."
	 */
	@PostMapping("register")
	@ResponseBody
	public ResponseEntity<String> register(@RequestParam String email, @RequestParam String password, @RequestParam String firstName, @RequestParam String lastName) {
		if (authService.registerUser(email, password, firstName, lastName)) {
			return new ResponseEntity<>(HttpStatus.CREATED);
		} else {
			return new ResponseEntity<>(HttpStatus.CONFLICT); 
		}
	}

	/**
	 * Método HTTP /auth/login (POST) para autenticar a un usuario.
	 *
	 * El metodo recibe un header de autorización con el formato "Basic <credenciales en base64>" (Los credenciales son
	 * el email y la contraseña del usuario separados por ":"). Si las credenciales son correctas, el metodo devuelve un
	 * token de autenticación. En caso contrario, devuelve un código de estado 403 (Forbidden).
	 *
	 * @return 200 OK con el token de autenticación si las credenciales son correctas.
	 * @see "403 Forbidden si las credenciales son incorrectas."
	 * @see "400 Bad Request si el header de autorización no tiene el formato correcto o falta el header."
	 **/
	@PostMapping(value = "login", produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public ResponseEntity<AuthenticationResponse> login(@RequestHeader(HttpHeaders.AUTHORIZATION) String authHeader) {
		ResponseEntity<AuthenticationResponse> response;
		String[] authParts = authHeader.split(" ");

		// Comprobamos que el header de autorización tiene el formato correcto
		if (authParts.length >= 2 && authParts[0].equals("Basic")) {
			// Obtenemos el token de autenticación haciendo login
			String token = authService.loginUser(authParts[1]);

			// Si el token no es nulo, devolvemos el token en la respuesta
			if (token != null) {
				response = ResponseEntity.ok(new AuthenticationResponse(token));
			} else { // Si el token es nulo, devolvemos un código de estado 403 (Forbidden) ya que las credenciales son incorrectas
				response = new ResponseEntity<>(HttpStatus.FORBIDDEN);
			}
		} else {
			// Si el header de autorización no tiene el formato correcto, devolvemos un código de estado 400 (Bad Request)
			response = new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
		
		return response;
	}
}
