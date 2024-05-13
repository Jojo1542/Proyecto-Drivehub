package es.iesmm.proyecto.drivehub.backend.model.user.driver.contract;

import es.iesmm.proyecto.drivehub.backend.model.user.driver.DriverModelData;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotEmpty;
import lombok.*;
import org.hibernate.validator.internal.util.Contracts;
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

    /*@OneToOne(mappedBy = "previousContract")
    private DriverContract previousContract;

    @OneToOne(mappedBy = "nextContract")
    private DriverContract nextContract;*/

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    private DriverModelData driver;

}
