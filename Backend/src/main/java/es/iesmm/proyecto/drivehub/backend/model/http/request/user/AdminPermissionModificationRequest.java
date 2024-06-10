package es.iesmm.proyecto.drivehub.backend.model.http.request.user;

import es.iesmm.proyecto.drivehub.backend.model.user.admin.permisison.AdminPermission;

import java.util.List;

public record AdminPermissionModificationRequest(List<String> permissions) {

    public List<AdminPermission> toAdminPermissions() {
        return permissions.stream()
                .map(AdminPermission::valueOf)
                .toList();
    }

}
