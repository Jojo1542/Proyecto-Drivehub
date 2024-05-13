package es.iesmm.proyecto.drivehub.backend.service.contract.impl;

import com.google.common.base.Preconditions;
import es.iesmm.proyecto.drivehub.backend.model.fleet.Fleet;
import es.iesmm.proyecto.drivehub.backend.model.http.request.contract.ContractCreationRequest;
import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.contract.DriverContract;
import es.iesmm.proyecto.drivehub.backend.repository.ContractRepository;
import es.iesmm.proyecto.drivehub.backend.repository.FleetRepository;
import es.iesmm.proyecto.drivehub.backend.repository.UserRepository;
import es.iesmm.proyecto.drivehub.backend.service.contract.ContractService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@AllArgsConstructor
public class SimpleContractService implements ContractService {

    private final ContractRepository contractRepository;
    private final FleetRepository fleetRepository;
    private final UserRepository userRepository;

    @Override
    public DriverContract createContract(ContractCreationRequest request) {
        UserModel userModel = userRepository.findById(request.driverId())
                .orElseThrow(() -> new NullPointerException("User not found"));

        Preconditions.checkNotNull(userModel.getDriverData(), "The user must have driver");

        Fleet fleet = fleetRepository.findById(request.fleetId())
                .orElseThrow(() -> new NullPointerException("Fleet not found"));

        DriverContract prevContract = userModel.getDriverData().getActualContract();

        DriverContract contract = request.toDriverContract(
                userModel.getDriverData(),
                fleet
        );

        // Actualizar el contrato anterior
        if (prevContract != null) {
            prevContract.setNextContract(contract);
            contractRepository.save(prevContract);

            // Establecer en el contrato actual el contrato anterior para poder hacer la relación bidireccional
            contract.setPreviousContract(prevContract);
        }

        return contractRepository.save(contract);
    }

    @Override
    public DriverContract updateContract(Long contractId, DriverContract contract) {
        Preconditions.checkNotNull(contractId, "The contract ID cannot be null");
        Preconditions.checkNotNull(contract, "The contract cannot be null");
        Preconditions.checkArgument(contractId.equals(contract.getId()), "The contract ID must be the same as the contract");
        return contractRepository.save(contract);
    }

    @Override
    public List<DriverContract> findAllByFleet(Long fleetId) {
        return contractRepository.findAllByFleetId(fleetId);
    }

    @Override
    public List<DriverContract> findAll() {
        return contractRepository.findAll();
    }

    @Override
    public Optional<DriverContract> findById(Long contractId) {
        return contractRepository.findById(contractId);
    }

    @Override
    public void deleteById(Long contractId) {
        Preconditions.checkNotNull(contractId, "The contract ID cannot be null");
        Preconditions.checkArgument(contractRepository.existsById(contractId), "The contract with ID " + contractId + " does not exist");
        contractRepository.deleteById(contractId);
    }

    @Override
    public List<DriverContract> findAllByDriver(UserModel user) {
        return contractRepository.findByDriverId(user.getId());
    }
}
