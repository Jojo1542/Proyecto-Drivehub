package es.iesmm.proyecto.drivehub.backend.model.http.request.user;

import es.iesmm.proyecto.drivehub.backend.model.user.roles.UserRoles;

import java.util.Date;
import java.util.List;

public record UserAdminModificationRequest(
        String email,
        String firstName,
        String lastName,
        String password,
        List<UserRoles> roles,
        Date birthDate,
        String phone,
        String DNI
) {
}
