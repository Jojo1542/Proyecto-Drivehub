package es.iesmm.proyecto.drivehub.backend.model.http.response.common;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.experimental.SuperBuilder;

@Data
@SuperBuilder
@JsonInclude(JsonInclude.Include.NON_NULL)
public class CommonResponse {

    @Builder.Default
    private boolean success = true;

    private String errorMessage;

}
