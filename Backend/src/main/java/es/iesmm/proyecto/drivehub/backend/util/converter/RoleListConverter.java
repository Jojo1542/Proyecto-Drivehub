package es.iesmm.proyecto.drivehub.backend.util.converter;

import es.iesmm.proyecto.drivehub.backend.model.user.roles.UserRoles;
import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

import javax.management.relation.Role;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import static java.util.Collections.emptyList;

@Converter
public class RoleListConverter implements AttributeConverter<List<UserRoles>, String> {
    private static final String SPLIT_CHAR = ";";

    @Override
    public String convertToDatabaseColumn(List<UserRoles> rolesList) {
        return rolesList != null ? rolesList.stream().map(Enum::toString).collect(Collectors.joining(SPLIT_CHAR)) : "";
    }

    @Override
    public List<UserRoles> convertToEntityAttribute(String string) {
        return string != null ? Arrays.stream(string.split(SPLIT_CHAR)).map(UserRoles::valueOf).collect(Collectors.toList()) : emptyList();
    }
}
