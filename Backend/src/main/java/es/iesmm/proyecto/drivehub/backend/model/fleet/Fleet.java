package es.iesmm.proyecto.drivehub.backend.model.fleet;

import jakarta.persistence.Entity;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.jpa.domain.AbstractPersistable;

@Entity
@Getter
@Setter
@AllArgsConstructor
public class Fleet extends AbstractPersistable<Long> {

}
