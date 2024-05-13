package es.iesmm.proyecto.drivehub.backend.model.ship.parcel;

import com.fasterxml.jackson.annotation.JsonIgnore;
import es.iesmm.proyecto.drivehub.backend.model.ship.Shipment;
import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.*;
import org.springframework.data.jpa.domain.AbstractPersistable;

@Table(name = "PAQUETE")
@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Parcel extends AbstractPersistable<Long> {

    @ManyToOne
    @JoinColumn(name = "shipment_id", insertable = false, updatable = false)
    private Shipment shipment;

    private String content;
    private int quantity;
    private double weight;

    @Override
    @JsonIgnore
    public boolean isNew() {
        return super.isNew();
    }
}
