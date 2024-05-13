package es.iesmm.proyecto.drivehub.backend.model.trip;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import es.iesmm.proyecto.drivehub.backend.model.trip.status.TripStatus;
import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotEmpty;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.jpa.domain.AbstractPersistable;

import java.sql.Time;
import java.util.Date;

@Table(
        name = "TRAYECTO"
)
@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class TripModel extends AbstractPersistable<Long> {

    @NotEmpty
    // Por defecto, un trayecto se crea en estado PENDING
    @Enumerated(EnumType.STRING)
    @Column(name = "trip_status")
    private TripStatus status = TripStatus.PENDING;

    @NotEmpty
    @Column(name = "trip_date")
    private String date;

    @NotEmpty
    private String startTime;

    // Puede ser null hasta que llegue a su destino
    private String endTime;

    @NotEmpty
    private String origin;

    @NotEmpty
    private String destination;

    // Puede ser null hasta que llegue a su destino
    private double price;

    // Puede ser null hasta que llegue a su destino
    private double distance;

    @NotEmpty
    private boolean sendPackage;

    private String vehicleModel;
    private String vehiclePlate;

    @ManyToOne(optional = true, cascade = CascadeType.ALL)
    @PrimaryKeyJoinColumn(name = "id")
    @JsonIgnoreProperties({"email", "password", "roles", "saldo", "phone"})
    private UserModel driver;

    @ManyToOne(optional = false, cascade = CascadeType.ALL)
    @PrimaryKeyJoinColumn(name = "id")
    private UserModel passenger;
}
