package es.iesmm.proyecto.drivehub.backend.model.ship;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import es.iesmm.proyecto.drivehub.backend.model.ship.parcel.Parcel;
import es.iesmm.proyecto.drivehub.backend.model.ship.status.ShipmentStatusType;
import es.iesmm.proyecto.drivehub.backend.model.ship.status.ShipmentStatusUpdate;
import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import jakarta.persistence.*;
import lombok.*;
import org.springframework.data.jpa.domain.AbstractPersistable;

import java.sql.Date;
import java.util.List;

@Table(name = "ENVIO")
@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Shipment extends AbstractPersistable<Long> {

    private String sourceAddress;
    private String destinationAddress;
    private Date shipmentDate;
    private Date deliveryDate;
    private boolean hidden;

    @Enumerated(EnumType.STRING)
    private ShipmentStatusType actualStatus;

    // Save the status history on the database
    @OneToMany(cascade = CascadeType.ALL, orphanRemoval = true)
    @JoinColumn(name = "shipment_id")
    private List<ShipmentStatusUpdate> statusHistory;

    // Save the parcels on the database
    @OneToMany(cascade = CascadeType.ALL, orphanRemoval = true)
    @JoinColumn(name = "shipment_id")
    private List<Parcel> parcels;

    @ManyToOne(optional = true, cascade = CascadeType.ALL)
    @JsonIgnoreProperties({"email", "password", "roles", "saldo", "phone"})
    private UserModel driver;

    @PrePersist
    public void prePersist() {
        // Añadir el estado inicial si no se ha especificado
        if (actualStatus == null) {
            actualStatus = ShipmentStatusType.PENDING_TO_PICK_UP;
        }

        if (statusHistory.isEmpty()) {
            statusHistory.add(ShipmentStatusUpdate.builder()
                    .updateDate(new Date(System.currentTimeMillis()))
                    .status(actualStatus)
                    .description("Su envio ha sido registrado y está pendiente de recogida en la dirección de origen.")
                    .build());
        }
    }

    @Override
    @JsonIgnore
    public boolean isNew() {
        return super.isNew();
    }
}
