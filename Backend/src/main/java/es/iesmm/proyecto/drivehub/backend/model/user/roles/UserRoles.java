package es.iesmm.proyecto.drivehub.backend.model.user.roles;

import org.springframework.security.core.GrantedAuthority;

public enum UserRoles {

    USER,
    ADMIN;

    public String getAuthorityName() {
        return "ROLE_" + name();
    }

    public GrantedAuthority getGrantedAuthority() {
        return this::getAuthorityName;
    }

}
