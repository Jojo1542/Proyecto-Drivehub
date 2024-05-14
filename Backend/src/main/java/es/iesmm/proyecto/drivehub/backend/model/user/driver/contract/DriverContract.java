package es.iesmm.proyecto.drivehub.backend.model.user.driver.contract;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.DriverModelData;
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
    private DriverContract nextContract;

    // Previous contract
    @OneToOne(fetch = FetchType.EAGER)
    private DriverContract previousContract;

    @ManyToOne(fetch = FetchType.EAGER, optional = false)
    @JsonIgnoreProperties("driverContracts")
    private DriverModelData driver;

}
