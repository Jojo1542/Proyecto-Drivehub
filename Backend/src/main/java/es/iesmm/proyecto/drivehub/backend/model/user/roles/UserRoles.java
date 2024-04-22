package es.iesmm.proyecto.drivehub.backend.model.user.roles;

import org.springframework.security.core.GrantedAuthority;

public enum UserRoles {

    USER,
    ADMIN,
    DRIVER_FLEET,
    DRIVER_CHAUFFEUR;

    public String getAuthorityName() {
        return "ROLE_" + name();
    }

    public GrantedAuthority getGrantedAuthority() {
        return this::getAuthorityName;
    }

}
