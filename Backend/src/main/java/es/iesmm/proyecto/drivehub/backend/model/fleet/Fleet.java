package es.iesmm.proyecto.drivehub.backend.model.fleet;

import es.iesmm.proyecto.drivehub.backend.model.fleet.vehicle.VehicleType;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Table;
import lombok.*;
import org.springframework.data.jpa.domain.AbstractPersistable;

@Table(
        name = "FLOTA_VEHICULOS"
)
@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Fleet extends AbstractPersistable<Long> {

    private String name;
    private String CIF;

    // Convert to String
    @Enumerated(EnumType.STRING)
    private VehicleType vehicleType;

}
