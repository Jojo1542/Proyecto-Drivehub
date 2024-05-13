package es.iesmm.proyecto.drivehub.backend.repository;

import es.iesmm.proyecto.drivehub.backend.model.ship.Shipment;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ShipmentRepository extends CrudRepository<Shipment, Long> {
    @Query("select s from Shipment s where s.driver.id = ?1")
    List<Shipment> findByDriverId(Long id);
}
