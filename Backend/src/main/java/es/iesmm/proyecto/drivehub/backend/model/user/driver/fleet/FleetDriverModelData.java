package es.iesmm.proyecto.drivehub.backend.model.user.driver.fleet;

import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.JsonIdentityReference;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;
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

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "fleet_id")
    @JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class, property = "id")
    @JsonIdentityReference(alwaysAsId = true)
    private Fleet fleet;

}
