package es.iesmm.proyecto.drivehub.backend.model.user.driver.contract;

import com.fasterxml.jackson.annotation.*;
import es.iesmm.proyecto.drivehub.backend.model.fleet.Fleet;
import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.DriverModelData;
import es.iesmm.proyecto.drivehub.backend.model.user.roles.UserRoles;
import jakarta.persistence.*;
import lombok.*;
import org.springframework.data.jpa.domain.AbstractPersistable;

import java.util.Date;

@Table(
        name = "CONTRATO"
)
@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class DriverContract extends AbstractPersistable<Long> {

    private Date startDate;
    private Date endDate;
    private double salary;

    // Next contract (renewal)
    @OneToOne(fetch = FetchType.EAGER)
    @JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class, property = "id")
    @JsonIdentityReference(alwaysAsId = true)
    private DriverContract nextContract;

    // Previous contract
    @OneToOne(fetch = FetchType.EAGER)
    @JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class, property = "id")
    @JsonIdentityReference(alwaysAsId = true)
    private DriverContract previousContract;

    // Fleet that makes the contract
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "fleet_id")
    @JsonIgnoreProperties("drivers")
    private Fleet fleet;

    @ManyToOne
    @JoinColumn(name = "driver_id")
    @JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class, property = "id")
    @JsonIdentityReference(alwaysAsId = true)
    private UserModel driver;

    @JsonIgnore
    @Override
    public boolean isNew() {
        return super.isNew();
    }

    public boolean isFleetContract() {
        return fleet != null;
    }

    @JsonIgnore
    public boolean isActual() {
        return !isExpired();
    }

    public boolean isExpired() {
        return endDate.before(new Date());
    }
}
