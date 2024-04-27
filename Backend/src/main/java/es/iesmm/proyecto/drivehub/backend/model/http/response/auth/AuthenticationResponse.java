package es.iesmm.proyecto.drivehub.backend.model.http.response.auth;

import es.iesmm.proyecto.drivehub.backend.model.http.response.common.CommonResponse;
import lombok.*;
import lombok.experimental.SuperBuilder;

@EqualsAndHashCode(callSuper = false)
@Data
@SuperBuilder
public class AuthenticationResponse extends CommonResponse {

    private String accessToken;

}
