package es.iesmm.proyecto.drivehub.backend.model.user.driver;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotEmpty;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

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

    @PrePersist
    public void defaultValues() {
        if (this.avaiableTime == null) {
            this.avaiableTime = "08:00-20:00";
        }
    }

}
