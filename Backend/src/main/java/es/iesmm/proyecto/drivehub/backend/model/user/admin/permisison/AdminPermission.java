package es.iesmm.proyecto.drivehub.backend.model.user.admin.permisison;

import org.springframework.security.core.GrantedAuthority;

public enum AdminPermission {

    SUPER_ADMIN,
    GET_ALL_USERS,
    SEE_USER_DETAILS,
    UPDATE_USER,
    DELETE_USER,
    CREATE_SHIPMENT,
    UPDATE_SHIPMENT,
    DELETE_SHIPMENT,
    LIST_ALL_RENTS,
    LIST_ALL_VEHICLES,
    GET_VEHICLE,
    CREATE_VEHICLE,
    UPDATE_VEHICLE,
    DELETE_VEHICLE,
    CREATE_FLEET,
    DELETE_FLEET,
    CREATE_GENERAL_CONTRACT,
    GET_GENERAL_CONTRACT,
    UPDATE_GENERAL_CONTRACT,
    DELETE_GENERAL_CONTRACT,
    LIST_RENTS_BY_USER;

    public String getAuthorityName() {
        return name();
    }

    public GrantedAuthority getGrantedAuthority() {
        return this::getAuthorityName;
    }
}
