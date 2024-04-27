package es.iesmm.proyecto.drivehub.backend.service.auth.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(value= HttpStatus.INTERNAL_SERVER_ERROR, reason="Unknown exception occurred")
public class UnknownRegisterException extends RuntimeException {

    public UnknownRegisterException(String message) {
        super(message);
    }

    public UnknownRegisterException(String message, Throwable cause) {
        super(message, cause);
    }

}
