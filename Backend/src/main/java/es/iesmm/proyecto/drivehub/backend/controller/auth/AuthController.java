package es.iesmm.proyecto.drivehub.backend.controller.auth;

import es.iesmm.proyecto.drivehub.backend.model.http.response.auth.AuthenticationResponse;
import es.iesmm.proyecto.drivehub.backend.model.http.response.common.CommonResponse;
import es.iesmm.proyecto.drivehub.backend.service.auth.AuthService;
import es.iesmm.proyecto.drivehub.backend.service.auth.exception.EmailAlreadyExistException;
import es.iesmm.proyecto.drivehub.backend.service.auth.exception.UnknownRegisterException;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@AllArgsConstructor
@RestController
@RequestMapping("/auth")
public class AuthController {

    private final AuthService authService;

    /**
     * Método HTTP /auth/register (POST) para registrar a un usuario.
     * <p>
     * El método recibe los parámetros email, password, firstName y lastName. Si el email no está en uso, el método
     * registra al usuario y devuelve un código de estado 201 (Created). En caso contrario, devuelve un código de estado
     * 409 (Conflict).
     *
     * @return 201 Created si el usuario se ha registrado correctamente.
     * @see "409 Conflict si el email ya está en uso."
     */
    @PostMapping("register")
    @ResponseBody
    public ResponseEntity<CommonResponse> register(@RequestParam String email, @RequestParam String password, @RequestParam String firstName, @RequestParam String lastName) throws UnknownRegisterException, EmailAlreadyExistException {
        ResponseEntity<CommonResponse> response;

        try {
            // Registramos al usuario en la base de datos, controlando las excepciones que puedan lanzarse en el proceso
            authService.registerUser(email, password, firstName, lastName);

            response = ResponseEntity.status(HttpStatus.CREATED).body(
                    CommonResponse.builder()
                            .success(true)
                            .build()
            );
        } catch (EmailAlreadyExistException e) { // Si el email ya está en uso, devolvemos un código de estado 409 (Conflict)
            response = ResponseEntity.status(HttpStatus.CONFLICT).body(
                    CommonResponse.builder()
                            .errorMessage("El email ya está en uso")
                            .success(false)
                            .build()
            );
        } catch (UnknownRegisterException e) { // Si hay un error al guardar el usuario, devolvemos un código de estado 500 (Internal Server Error)
            response = ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(
                    CommonResponse.builder()
                            .errorMessage("Error al guardar el usuario")
                            .success(false)
                            .build()
            );
        }

        return response;
    }

    /**
     * Método HTTP /auth/login (POST) para autenticar a un usuario.
     * <p>
     * El metodo recibe un header de autorización con el formato "Basic <credenciales en base64>" (Los credenciales son
     * el email y la contraseña del usuario separados por ":"). Si las credenciales son correctas, el metodo devuelve un
     * token de autenticación. En caso contrario, devuelve un código de estado 403 (Forbidden).
     *
     * @return 200 OK con el token de autenticación si las credenciales son correctas.
     * @see "401 Unauthorized si las credenciales son incorrectas."
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
                response = ResponseEntity.ok(AuthenticationResponse.builder().accessToken(token).build());
            } else { // Si el token es nulo, devolvemos un código de estado 403 (Forbidden) ya que las credenciales son incorrectas
                response = ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(
                        AuthenticationResponse.builder()
                                .success(false)
                                .errorMessage("Credenciales incorrectas")
                                .build()
                );
            }
        } else {
            // Si el header de autorización no tiene el formato correcto, devolvemos un código de estado 400 (Bad Request)
            response = ResponseEntity.badRequest().body(
                    AuthenticationResponse.builder()
                            .errorMessage("Formato de autorización incorrecto")
                            .success(false)
                            .build()
            );
        }

        return response;
    }
}
