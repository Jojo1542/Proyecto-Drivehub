package es.iesmm.proyecto.drivehub.backend.model.ship.status;

import com.fasterxml.jackson.annotation.JsonIgnore;
import es.iesmm.proyecto.drivehub.backend.model.ship.Shipment;
import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.*;
import org.springframework.data.jpa.domain.AbstractPersistable;

import java.util.Date;

@Table(name = "ESTADO_ENVIO")
@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ShipmentStatusUpdate extends AbstractPersistable<Long> {

    @ManyToOne
    @JoinColumn(name = "shipment_id", insertable = false, updatable = false)
    @JsonIgnore
    private Shipment shipment;

    private Date updateDate;
    private ShipmentStatusType status;
    private String description;

    @Override
    @JsonIgnore
    public boolean isNew() {
        return super.isNew();
    }
}
