package es.iesmm.proyecto.drivehub.backend.util.permission;

import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import es.iesmm.proyecto.drivehub.backend.model.user.admin.permisison.AdminPermission;
import es.iesmm.proyecto.drivehub.backend.model.user.roles.UserRoles;

public class PermissionUtils {

    public static boolean hasRole(UserModel userModel, String role) {
        return hasRole(userModel, UserRoles.valueOf(role));
    }

    public static boolean hasRole(UserModel userModel, UserRoles role) {
        return userModel.getRoles().contains(role);
    }

    public static boolean hasAdminPermission(UserModel userModel, String authority) {
        return hasAdminPermission(userModel, AdminPermission.valueOf(authority));
    }

    public static boolean hasAdminPermission(UserModel userModel, AdminPermission authority) {
        return  userModel.getAuthorities().stream().anyMatch(r -> r.getAuthority().equals(authority.name()));
    }

    public static boolean hasFleetPermission(UserModel userModel, Long fleetId) {
        if (fleetId == null) { // If the fleetId is null, the user does not have permission
            return false;
        }

        return userModel.getAuthorities().stream().anyMatch(r -> r.getAuthority().equals("FLEET_" + fleetId));
    }

    public static boolean hasFleetPermissionAndGrant(UserModel userModel, Long fleetId, AdminPermission authority) {
        return hasFleetPermission(userModel, fleetId) && hasAdminPermission(userModel, authority);
    }

    public static boolean hasFleetPermissionAndGrant(UserModel userModel, Long fleetId, String authority) {
        return hasFleetPermissionAndGrant(userModel, fleetId, AdminPermission.valueOf(authority));
    }

}
