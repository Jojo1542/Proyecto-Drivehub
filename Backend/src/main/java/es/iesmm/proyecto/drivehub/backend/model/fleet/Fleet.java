package es.iesmm.proyecto.drivehub.backend.model.fleet;

import com.fasterxml.jackson.annotation.JsonIgnore;
import es.iesmm.proyecto.drivehub.backend.model.fleet.vehicle.VehicleType;
import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.contract.DriverContract;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.fleet.FleetDriverModelData;
import jakarta.persistence.*;
import lombok.*;
import org.springframework.data.jpa.domain.AbstractPersistable;

import java.util.List;

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

    // One fleet can have multiple drivers
    @OneToMany(mappedBy = "fleet", fetch = FetchType.EAGER)
    @JsonIgnore
    private List<FleetDriverModelData> drivers;

    @JsonIgnore
    @Override
    public boolean isNew() {
        return super.isNew();
    }
}
