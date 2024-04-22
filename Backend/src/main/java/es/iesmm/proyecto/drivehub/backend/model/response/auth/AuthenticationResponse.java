package es.iesmm.proyecto.drivehub.backend.model.response.auth;

import com.fasterxml.jackson.annotation.JsonProperty;

public class AuthenticationResponse {
	
	@JsonProperty private final String accessToken;

	public AuthenticationResponse(String token) {
		this.accessToken = token;
	}
}
