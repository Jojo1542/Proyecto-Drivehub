package es.iesmm.proyecto.drivehub.backend.model.rent.vehicle;

import es.iesmm.proyecto.drivehub.backend.model.rent.history.UserRent;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotEmpty;
import lombok.*;
import org.springframework.data.jpa.domain.AbstractPersistable;

import java.util.Date;
import java.util.Set;

@Table(
        name = "VEHICULOS_ALQUILER",
        uniqueConstraints = {
                @UniqueConstraint(name = "UQ_RENT_PLATE", columnNames="plate"),
                @UniqueConstraint(name = "UQ_RENT_NUM_BASTIDOR", columnNames="numero_bastidor")
        }
)
@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class RentCar extends AbstractPersistable<Long> {


    @NotEmpty
    @Column(name = "plate")
    private String plate;

    @NotEmpty
    @Column(name = "numero_bastidor")
    private String numBastidor;

    private String brand;
    private String model;
    private String color;
    private Date fechaMatriculacion;

    // check that price is not negative
    @Column(name = "price_per_hour")
    @NotEmpty
    private double precioHora;

    @OneToMany(mappedBy = "vehicle")
    private Set<UserRent> userRent;

}
