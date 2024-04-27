package es.iesmm.proyecto.drivehub.backend.model.user.admin.permisison;

import org.springframework.security.core.GrantedAuthority;

public enum AdminPermission {

    SUPER_ADMIN,
    GET_ALL_USERS,
    SEE_USER_DETAILS,
    UPDATE_USER,
    DELETE_USER;

    public String getAuthorityName() {
        return name();
    }

    public GrantedAuthority getGrantedAuthority() {
        return this::getAuthorityName;
    }
}
