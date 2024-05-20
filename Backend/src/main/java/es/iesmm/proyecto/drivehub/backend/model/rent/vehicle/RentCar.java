package es.iesmm.proyecto.drivehub.backend.model.rent.vehicle;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import es.iesmm.proyecto.drivehub.backend.model.rent.history.UserRent;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotEmpty;
import lombok.*;
import org.springframework.data.jpa.domain.AbstractPersistable;

import java.util.Date;
import java.util.HashSet;
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
    private String imageUrl;

    // check that price is not negative
    @Column(name = "price_per_hour")
    private double precioHora;

    @OneToMany(mappedBy = "vehicle", fetch = FetchType.EAGER, orphanRemoval = true)
    @JsonIgnore
    private Set<UserRent> userRent = new HashSet<>();

    public boolean isAvailable() {
        return userRent.stream().noneMatch(UserRent::isActive);
    }

    @JsonIgnore
    @Override
    public boolean isNew() {
        return super.isNew();
    }
}
