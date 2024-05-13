package es.iesmm.proyecto.drivehub.backend.repository;

import es.iesmm.proyecto.drivehub.backend.model.fleet.Fleet;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface FleetRepository extends JpaRepository<Fleet, Long> {

    @Query("SELECT f FROM Fleet f WHERE f.CIF = ?1")
    Optional<Fleet> findByCIF(String cif);
}
