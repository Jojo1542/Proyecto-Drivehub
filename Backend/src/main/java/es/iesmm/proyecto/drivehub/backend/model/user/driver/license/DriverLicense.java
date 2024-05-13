package es.iesmm.proyecto.drivehub.backend.model.user.driver.license;

import es.iesmm.proyecto.drivehub.backend.model.user.driver.DriverModelData;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.license.type.DriverLicenseType;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotEmpty;
import lombok.*;

import java.util.Date;

@Table(
        name = "PERMISO_CONDUCCION"
)
@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class DriverLicense {

    @Id
    @NotEmpty
    @Column(name = "license_number")
    private String licenseNumber;

    @Enumerated(EnumType.STRING)
    private DriverLicenseType type;
    private Date expirationDate;
    private Date issueDate;

    @ManyToOne
    @JoinColumn(name = "id_usuario")
    private DriverModelData driver;

}
