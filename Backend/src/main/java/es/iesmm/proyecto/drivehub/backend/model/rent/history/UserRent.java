package es.iesmm.proyecto.drivehub.backend.model.rent.history;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import es.iesmm.proyecto.drivehub.backend.model.rent.history.key.UserRentKey;
import es.iesmm.proyecto.drivehub.backend.model.rent.vehicle.RentCar;
import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import jakarta.persistence.*;
import lombok.*;

import java.io.Serializable;
import java.sql.Timestamp;

@Entity
@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class UserRent {

    @EmbeddedId
    @JsonIgnore
    private UserRentKey rentKey;

    @ManyToOne
    @MapsId("user_id")
    @JoinColumn(name = "user_id")
    @JsonManagedReference
    private UserModel user;

    @ManyToOne
    @MapsId("vehicle_id")
    @JoinColumn(name = "vehicle_id")
    @JsonManagedReference
    private RentCar vehicle;

    @Column(name = "start_time", insertable = false, updatable = false)
    private Timestamp startTime;

    @Column(name = "end_time")
    private Timestamp endTime;

    @Column(name = "active")
    private boolean active;

    @Column(name = "final_price")
    private double finalPrice;

    public void generateKey() {
        this.rentKey = new UserRentKey(
                this.user.getId(),
                this.vehicle.getId(),
                this.startTime
        );
    }

    @PostPersist
    public void postPersist() {
        if (this.startTime == null) {
            this.startTime = new Timestamp(System.currentTimeMillis());
        }

        if (this.endTime == null) {
            this.active = true;
        } else {
            this.active = false;
        }
    }

}
