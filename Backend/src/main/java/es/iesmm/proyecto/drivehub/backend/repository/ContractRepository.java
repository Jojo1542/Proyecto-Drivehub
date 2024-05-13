package es.iesmm.proyecto.drivehub.backend.repository;

import es.iesmm.proyecto.drivehub.backend.model.user.driver.contract.DriverContract;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ContractRepository extends JpaRepository<DriverContract, Long> {

    @Query("SELECT c FROM DriverContract c WHERE c.driver.id = :driverId")
    List<DriverContract> findByDriverId(Long driverId);

    @Query("SELECT c FROM DriverContract c WHERE c.fleet.id = :fleetId")
    List<DriverContract> findAllByFleetId(Long fleetId);

}
