package es.iesmm.proyecto.drivehub.backend.model.user.driver;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.contract.DriverContract;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.license.DriverLicense;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotEmpty;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

import java.util.Set;

@Table(name = "CONDUCTORES")
@DiscriminatorColumn(name = "tipo_conductor")
@Inheritance(strategy = InheritanceType.JOINED)
@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public abstract class DriverModelData {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @JsonIgnore
    private Long id;

    @NotEmpty
    @Column(name = "horario")
    @ColumnDefault("'08:00-20:00'")
    private String avaiableTime;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_usuario")
    @JsonIgnore
    private UserModel userModel;

    @OneToMany(mappedBy = "driver")
    @JsonIgnoreProperties("driver")
    private Set<DriverLicense> driverLicense;

    @OneToMany(mappedBy = "driver")
    private Set<DriverContract> driverContracts;


    @PrePersist
    public void defaultValues() {
        if (this.avaiableTime == null) {
            this.avaiableTime = "08:00-20:00";
        }
    }

}
