package es.iesmm.proyecto.drivehub.backend.util.converter;

import es.iesmm.proyecto.drivehub.backend.model.user.admin.permisison.AdminPermission;
import es.iesmm.proyecto.drivehub.backend.model.user.roles.UserRoles;
import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;
import java.util.stream.Collectors;

import static java.util.Collections.emptyList;

@Converter
public class AdminPermissionListConverter implements AttributeConverter<List<AdminPermission>, String> {
    private static final String SPLIT_CHAR = ";";

    @Override
    public String convertToDatabaseColumn(List<AdminPermission> rolesList) {
        return rolesList != null ? rolesList.stream().map(AdminPermission::name).collect(Collectors.joining(SPLIT_CHAR)) : "";
    }

    @Override
    public List<AdminPermission> convertToEntityAttribute(String string) {
        return string != null ? Arrays.stream(string.split(SPLIT_CHAR)).map(AdminPermission::valueOf).collect(Collectors.toList()) : new LinkedList<>();
    }
}
