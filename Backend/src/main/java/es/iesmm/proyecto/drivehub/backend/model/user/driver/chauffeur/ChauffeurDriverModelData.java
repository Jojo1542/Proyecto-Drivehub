package es.iesmm.proyecto.drivehub.backend.model.user.driver.chauffeur;

import es.iesmm.proyecto.drivehub.backend.model.user.driver.DriverModelData;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

@Entity
@Table(name = "CONDUCTORES_CHOFER")
@DiscriminatorValue("CHOFER")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ChauffeurDriverModelData extends DriverModelData {

    @Column(name = "prefered_distance")
    @ColumnDefault("10")
    private int preferedDistance;

    @Column(name = "take_passengers")
    @ColumnDefault("0")
    private boolean canTakePassengers;
}
