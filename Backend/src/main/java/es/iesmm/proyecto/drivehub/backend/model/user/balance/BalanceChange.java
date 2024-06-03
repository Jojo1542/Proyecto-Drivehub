package es.iesmm.proyecto.drivehub.backend.model.user.balance;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import es.iesmm.proyecto.drivehub.backend.model.user.balance.type.BalanceChangeType;
import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.*;
import org.springframework.data.jpa.domain.AbstractPersistable;

import java.util.Date;

@Table(name = "HISTORIAL_SALDO")
@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class BalanceChange extends AbstractPersistable<Long> {

    @ManyToOne
    @JoinColumn(name = "user_id", insertable = false, updatable = false)
    @JsonIgnore
    private UserModel user;

    private BalanceChangeType type;
    private double amount;

    @JsonProperty("date") // El front-end espera que se llame "date"
    private Date registerDate;

    @Override
    @JsonIgnore
    public boolean isNew() {
        return super.isNew();
    }

}
