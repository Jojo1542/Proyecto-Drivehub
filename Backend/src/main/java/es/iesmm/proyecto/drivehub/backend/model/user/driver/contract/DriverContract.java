package es.iesmm.proyecto.drivehub.backend.model.user.driver.contract;

import es.iesmm.proyecto.drivehub.backend.model.fleet.Fleet;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.DriverModelData;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotEmpty;
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

    @NotEmpty
    private Date startDate;

    @NotEmpty
    private Date endDate;

    @NotEmpty
    private double salary;

    // Next contract (renewal)
    @OneToOne(fetch = FetchType.LAZY)
    private DriverContract nextContract;

    // Previous contract
    @OneToOne(fetch = FetchType.LAZY)
    private DriverContract previousContract;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    private DriverModelData driver;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    private Fleet fleet;

}
