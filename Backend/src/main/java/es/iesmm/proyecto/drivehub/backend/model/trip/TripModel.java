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

    // Por defecto, un trayecto se crea en estado PENDING
    @Enumerated(EnumType.STRING)
    @Column(name = "trip_status")
    private TripStatus status = TripStatus.PENDING;

    @Column(name = "trip_date")
    private Date date;

    private Date startTime;

    // Puede ser null hasta que llegue a su destino
    private Date endTime;

    @NotEmpty
    private String origin;

    @NotEmpty
    private String destination;

    @NotEmpty
    private String originAddress;

    @NotEmpty
    private String destinationAddress;

    private double price;

    private double distance;

    private boolean sendPackage;

    private String vehicleModel;
    private String vehiclePlate;
    private String vehicleColor;

    @ManyToOne
    @JsonIgnoreProperties({"email", "password", "roles", "saldo", "phone", "adminData", "driverData", "balanceHistory"})
    @JoinColumn(name = "driver_id")
    private UserModel driver;

    @ManyToOne(optional = false)
    @JoinColumn(name = "passenger_id", nullable = false)
    @JsonIgnoreProperties({"balanceHistory"})
    private UserModel passenger;

    @JsonIgnore
    public boolean isActive() {
        return status == TripStatus.ACCEPTED || status == TripStatus.PENDING;
    }
}
