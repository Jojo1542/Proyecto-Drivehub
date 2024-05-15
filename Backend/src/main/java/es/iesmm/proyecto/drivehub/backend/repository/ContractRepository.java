package es.iesmm.proyecto.drivehub.backend.repository;

import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.DriverModelData;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.contract.DriverContract;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ContractRepository extends JpaRepository<DriverContract, Long> {

    @Query("SELECT c FROM DriverContract c WHERE c.driver.id = :id")
    List<DriverContract> findByDriver(Long id);

    @Query("SELECT c FROM DriverContract c WHERE c.fleet IS null")
    List<DriverContract> findAllGeneral();

    @Query("SELECT c FROM DriverContract c WHERE c.fleet.id = :fleetId")
    List<DriverContract> findAllByFleet(Long fleetId);

    @Query("SELECT c FROM DriverContract c WHERE c.id = :contractId AND c.fleet IS null")
    Optional<DriverContract> findGeneralById(Long contractId);


    @Query("SELECT c FROM DriverContract c WHERE c.id = :contractId AND c.fleet.id = :fleetId")
    Optional<DriverContract> findContractByIdFleet(Long contractId, Long fleetId);
}
