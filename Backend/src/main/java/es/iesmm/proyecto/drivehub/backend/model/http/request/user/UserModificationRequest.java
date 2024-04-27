package es.iesmm.proyecto.drivehub.backend.model.http.request.user;

import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Date;

public record UserModificationRequest(String email, String password, Date birthDate, String dni, String phone, String firstName, String lastName) {

    /*
     * Aplica los cambios de la petición al usuario especificado (Usualmente el usuario autenticado)
     * @param user El usuario al que se le aplicarán los cambios
     * @see UserModel
     */
    public void applyToUser(UserModel user) {
        if (email() != null) {
            user.setEmail(email());
        }

        if (password() != null) {
            user.setPassword(password());
        }

        if (birthDate() != null) {
            user.setBirthDate(birthDate());
        }

        if (dni() != null) {
            user.setDNI(dni());
        }

        if (phone() != null) {
            user.setPhone(phone());
        }

        if (firstName() != null) {
            user.setFirstName(firstName());
        }

        if (lastName() != null) {
            user.setLastName(lastName());
        }
    }
}
