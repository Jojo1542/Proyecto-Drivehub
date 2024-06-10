package es.iesmm.proyecto.drivehub.backend.config;

import es.iesmm.proyecto.drivehub.backend.util.jackson.unix.UnixTimeModule;
import org.springframework.boot.autoconfigure.jackson.Jackson2ObjectMapperBuilderCustomizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class JacksonConfig {

    @Bean
    public Jackson2ObjectMapperBuilderCustomizer unixModuleApplier() {
        return builder -> builder.modules(new UnixTimeModule());
    }
}
