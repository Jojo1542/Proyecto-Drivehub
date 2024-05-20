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

import java.sql.Date;
import java.util.HashSet;
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

    @OneToOne(mappedBy = "driverData")
    @JsonIgnore
    private UserModel userModel;

    @PrePersist
    public void defaultValues() {
        if (this.avaiableTime == null) {
            this.avaiableTime = "08:00-20:00";
        }
    }

    public void setUserModel(UserModel userModel) {
        this.userModel = userModel;
        if (userModel.getDriverData() != this) {
            userModel.setDriverData(this);
        }
    }
}
