package es.iesmm.proyecto.drivehub.backend.model.trip;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import es.iesmm.proyecto.drivehub.backend.model.trip.status.TripStatus;
import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotEmpty;
import lombok.*;
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
@Builder
public class TripModel extends AbstractPersistable<Long> {

    @NotEmpty
    // Por defecto, un trayecto se crea en estado PENDING
    @Enumerated(EnumType.STRING)
    @Column(name = "trip_status")
    private TripStatus status = TripStatus.PENDING;

    @NotEmpty
    @Column(name = "trip_date")
    private Date date;

    @NotEmpty
    private Date startTime;

    // Puede ser null hasta que llegue a su destino
    private Date endTime;

    @NotEmpty
    private String origin;

    @NotEmpty
    private String destination;

    private double price;

    private double distance;

    private boolean sendPackage;

    private String vehicleModel;
    private String vehiclePlate;
    private String vehicleColor;

    @ManyToOne(cascade = CascadeType.ALL)
    @PrimaryKeyJoinColumn(name = "id")
    @JsonIgnoreProperties({"email", "password", "roles", "saldo", "phone", "adminData", "driverData"})
    private UserModel driver;

    @ManyToOne(optional = false, cascade = CascadeType.ALL)
    @PrimaryKeyJoinColumn(name = "id")
    private UserModel passenger;

    @JsonIgnore
    public boolean isActive() {
        return status == TripStatus.ACCEPTED || status == TripStatus.PENDING;
    }
}
