package es.iesmm.proyecto.drivehub.backend.service.contract;

import es.iesmm.proyecto.drivehub.backend.model.http.request.contract.ContractCreationRequest;
import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.contract.DriverContract;

import java.util.List;
import java.util.Optional;

public interface ContractService {

    DriverContract createContract(ContractCreationRequest request);

    DriverContract updateContract(Long contractId, DriverContract contract);


    List<DriverContract> findAllByFleet(Long fleetId);

    List<DriverContract> findAll();

    Optional<DriverContract> findById(Long contractId);

    void deleteById(Long contractId);

    List<DriverContract> findAllByDriver(UserModel user);
}
