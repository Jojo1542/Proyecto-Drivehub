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
import java.util.Collections;
import java.util.LinkedList;
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
    private List<ShipmentStatusUpdate> statusHistory = new LinkedList<>();

    // Save the parcels on the database
    @OneToMany(cascade = CascadeType.ALL, orphanRemoval = true)
    @JoinColumn(name = "shipment_id")
    private List<Parcel> parcels = new LinkedList<>();

    @ManyToOne(optional = true, cascade = CascadeType.ALL)
    @JsonIgnoreProperties({"email", "password", "roles", "saldo", "phone", "adminData", "driverData"})
    private UserModel driver;

    @PrePersist
    public void prePersist() {
        // Añadir el estado inicial si no se ha especificado
        if (actualStatus == null) {
            actualStatus = ShipmentStatusType.PENDING_TO_PICK_UP;
        }

        // Añadir el historial si no hay historial
        if (statusHistory == null || statusHistory.isEmpty()) {
            statusHistory = new LinkedList<>();

            statusHistory.add(ShipmentStatusUpdate.builder()
                    .updateDate(new Date(System.currentTimeMillis()))
                    .status(actualStatus)
                    .description("Su envio ha sido registrado y está pendiente de recogida en la dirección de origen.")
                    .build());
        }

        // Si no hay paquetes, crear el array vacío
        if (parcels == null) {
            parcels = new LinkedList<>();
        }
    }

    public ShipmentStatusType getActualStatus() {
        return hidden ? ShipmentStatusType.HIDDEN : actualStatus;
    }

    public List<ShipmentStatusUpdate> getStatusHistory() {
        return hidden ? Collections.emptyList() : statusHistory;
    }

    public void setParcels(List<Parcel> parcels) {
        // Limpiar los paquetes
        this.parcels.clear();

        if (parcels != null) {
            // Añadir los paquetes
            this.parcels.addAll(parcels);
        }
    }

    @Override
    @JsonIgnore
    public boolean isNew() {
        return super.isNew();
    }
}
