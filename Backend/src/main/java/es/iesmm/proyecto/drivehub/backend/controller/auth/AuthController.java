package es.iesmm.proyecto.drivehub.backend.controller.auth;

import java.util.logging.Logger;

import es.iesmm.proyecto.drivehub.backend.model.response.auth.AuthenticationResponse;
import es.iesmm.proyecto.drivehub.backend.service.auth.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/auth")
public class AuthController {

	@Autowired
	private AuthService authService;
	
	@PostMapping(path)
	@ResponseBody
	public ResponseEntity<String> register(@RequestParam String email, @RequestParam String password, @RequestParam String firstName, @RequestParam String lastName) {
		if (authService.registerUser(email, password, firstName, lastName)) {
			return new ResponseEntity<>(HttpStatus.CREATED);
		} else {
			return new ResponseEntity<>(HttpStatus.CONFLICT); 
		}
	}
	
	@PostMapping(value = "login", produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public ResponseEntity<AuthenticationResponse> login(@RequestHeader(HttpHeaders.AUTHORIZATION) String authHeader) {
		ResponseEntity<AuthenticationResponse> response;
		String[] authParts = authHeader.split(" ");
		
		if (authParts.length >= 2 && authParts[0].equals("Basic")) {
			String token = authService.loginUser(authParts[1]);
			if (token != null) {
				response = ResponseEntity.ok(new AuthenticationResponse(token));
			} else {
				response = new ResponseEntity<>(HttpStatus.FORBIDDEN);
			}
		} else {
			response = new ResponseEntity<>(HttpStatus.FORBIDDEN);
		}
		
		return response;
	}
}
