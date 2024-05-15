package es.iesmm.proyecto.drivehub.backend.util.converter;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;
import java.util.stream.Collectors;

import static java.util.Collections.emptyList;

@Converter
public class LongListConverter implements AttributeConverter<List<Long>, String> {
    private static final String SPLIT_CHAR = ";";

    @Override
    public String convertToDatabaseColumn(List<Long> longList) {
        return longList != null ? longList.stream().map(String::valueOf).collect(Collectors.joining(SPLIT_CHAR)) : "";
    }

    @Override
    public List<Long> convertToEntityAttribute(String string) {
        return string != null ? Arrays.stream(string.split(SPLIT_CHAR)).filter(s -> !s.isBlank()).map(Long::parseLong).collect(Collectors.toList()) : new LinkedList<>();
    }
}
