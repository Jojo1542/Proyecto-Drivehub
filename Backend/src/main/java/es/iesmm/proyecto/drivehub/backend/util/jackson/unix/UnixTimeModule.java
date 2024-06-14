package es.iesmm.proyecto.drivehub.backend.util.jackson.unix;

import com.fasterxml.jackson.databind.module.SimpleModule;
import es.iesmm.proyecto.drivehub.backend.util.jackson.unix.deserializer.DateUnixDeserializer;
import es.iesmm.proyecto.drivehub.backend.util.jackson.unix.deserializer.InstantUnixDeserializer;
import es.iesmm.proyecto.drivehub.backend.util.jackson.unix.deserializer.SqlDateUnixDeserializer;
import es.iesmm.proyecto.drivehub.backend.util.jackson.unix.serializer.DateUnixSerializer;
import es.iesmm.proyecto.drivehub.backend.util.jackson.unix.serializer.InstantUnixSerializer;
import es.iesmm.proyecto.drivehub.backend.util.jackson.unix.serializer.SqlDateUnixSerializer;

import java.time.Instant;
import java.util.Date;

public class UnixTimeModule extends SimpleModule {

    /*
     * Este módulo de Jackson se encarga de serializar y deserializar fechas en formato Unix
     * ya que Alamofire en iOS utiliza este formato para las fechas.
     */

    public UnixTimeModule() {
        addSerializer(Instant.class, new InstantUnixSerializer());
        addSerializer(Date.class, new DateUnixSerializer());
        addSerializer(java.sql.Date.class, new SqlDateUnixSerializer());

        addDeserializer(Instant.class, new InstantUnixDeserializer());
        addDeserializer(Date.class, new DateUnixDeserializer());
        addDeserializer(java.sql.Date.class, new SqlDateUnixDeserializer());
    }
}
