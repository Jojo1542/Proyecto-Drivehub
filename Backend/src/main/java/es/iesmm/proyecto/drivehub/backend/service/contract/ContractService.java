package es.iesmm.proyecto.drivehub.backend.service.contract;

import es.iesmm.proyecto.drivehub.backend.model.http.request.contract.ContractCreationRequest;
import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.contract.DriverContract;

import java.util.List;
import java.util.Optional;

public interface ContractService {

    DriverContract createContract(ContractCreationRequest request);

    Optional<DriverContract> getActualContract(UserModel user);

    List<DriverContract> findByDriver(UserModel user);

    List<DriverContract> findAll();

    List<DriverContract> findAllGeneral();

    List<DriverContract> findAllByFleet(Long fleetId);

    Optional<DriverContract> findById(Long contractId);

    Optional<DriverContract> findGeneralById(Long contractId);

    Optional<DriverContract> findContractByIdFleet(Long driverId, Long fleetId);

    void deleteById(Long contractId);

    void finalizeContract(Long contractId);
}
