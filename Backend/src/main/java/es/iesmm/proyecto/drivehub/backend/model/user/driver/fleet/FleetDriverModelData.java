package es.iesmm.proyecto.drivehub.backend.model.user.driver.fleet;

import es.iesmm.proyecto.drivehub.backend.model.fleet.Fleet;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.DriverModelData;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

@Entity
@Table(name = "CONDUCTORES_FLOTA")
@DiscriminatorValue("FLOTA")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class FleetDriverModelData extends DriverModelData {

    @Column(name = "max_tonnage")
    @ColumnDefault("10")
    public double maxTonnage;

    @ManyToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "fleet_id")
    private Fleet fleet;

}
