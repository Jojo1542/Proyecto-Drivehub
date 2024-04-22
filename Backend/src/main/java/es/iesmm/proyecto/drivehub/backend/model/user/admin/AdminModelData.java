package es.iesmm.proyecto.drivehub.backend.model.user.admin;

import com.fasterxml.jackson.annotation.JsonIgnore;
import es.iesmm.proyecto.drivehub.backend.util.converter.RoleListConverter;
import es.iesmm.proyecto.drivehub.backend.util.converter.StringListConverter;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotEmpty;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Collections;
import java.util.List;

@Table(name = "ADMINISTRADOR")
@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class AdminModelData {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @JsonIgnore
    private Long id;

    @Column(name = "permisos")
    @Convert(converter = StringListConverter.class)
    private List<String> fleetPermissions;

    @NotEmpty
    @Column(name = "horario")
    private String avaiableTime;

    @PrePersist
    public void defaultValues() {
        if (this.avaiableTime == null) {
            this.avaiableTime = "08:00-20:00";
        }

        if (this.fleetPermissions == null) {
            this.fleetPermissions = Collections.emptyList();
        }
    }
}
