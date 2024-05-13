package es.iesmm.proyecto.drivehub.backend.model.rent.history.key;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.sql.Timestamp;

@Embeddable
@NoArgsConstructor
@AllArgsConstructor
public class UserRentKey implements Serializable {

    @Column(name = "user_id")
    private Long user_id;

    @Column(name = "vehicle_id")
    private Long vehicle_id;

    @Column(name = "start_time")
    private Timestamp start_time;

}
