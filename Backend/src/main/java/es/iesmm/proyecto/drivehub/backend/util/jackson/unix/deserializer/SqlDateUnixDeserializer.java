package es.iesmm.proyecto.drivehub.backend.util.jackson.unix.deserializer;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;

import java.io.IOException;
import java.time.Instant;
import java.sql.Date;

public class SqlDateUnixDeserializer extends JsonDeserializer<Date> {

    @Override
    public Date deserialize(JsonParser p, DeserializationContext ctxt) throws IOException {
        return new Date(Instant.ofEpochSecond(p.getLongValue()).toEpochMilli());
    }

}
