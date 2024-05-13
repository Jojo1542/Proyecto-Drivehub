package es.iesmm.proyecto.drivehub.backend.model.rent.history;

import es.iesmm.proyecto.drivehub.backend.model.rent.vehicle.RentCar;
import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import jakarta.persistence.*;
import lombok.Data;

import java.io.Serializable;
import java.sql.Timestamp;

@Entity
public class UserRent {

    @EmbeddedId
    private UserRentKey rentKey;

    @ManyToOne
    @MapsId("user_id")
    @JoinColumn(name = "user_id")
    private UserModel user;

    @ManyToOne
    @MapsId("vehicle_id")
    @JoinColumn(name = "vehicle_id")
    private RentCar vehicle;

    @Column(name = "start_time")
    private Timestamp startTime;

    @Column(name = "end_time")
    private Timestamp endTime;

    @Column(name = "active")
    private boolean active;

    @PostPersist
    public void postPersist() {
        if (this.startTime == null) {
            this.startTime = new Timestamp(System.currentTimeMillis());
            this.active = true;
        }

        if (this.endTime == null) {
            this.active = true;
        }
    }

    @Embeddable
    @Data
    public static class UserRentKey implements Serializable {
        @Column(name = "user_id")
        private Long user_id;

        @Column(name = "vehicle_id")
        private Long vehicle_id;
    }

}
