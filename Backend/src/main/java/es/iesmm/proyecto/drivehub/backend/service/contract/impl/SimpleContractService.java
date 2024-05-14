package es.iesmm.proyecto.drivehub.backend.service.contract.impl;

import com.google.common.base.Preconditions;
import es.iesmm.proyecto.drivehub.backend.model.fleet.Fleet;
import es.iesmm.proyecto.drivehub.backend.model.http.request.contract.ContractCreationRequest;
import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.DriverModelData;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.chauffeur.ChauffeurDriverModelData;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.contract.DriverContract;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.fleet.FleetDriverModelData;
import es.iesmm.proyecto.drivehub.backend.model.user.roles.UserRoles;
import es.iesmm.proyecto.drivehub.backend.repository.ContractRepository;
import es.iesmm.proyecto.drivehub.backend.repository.FleetRepository;
import es.iesmm.proyecto.drivehub.backend.repository.UserRepository;
import es.iesmm.proyecto.drivehub.backend.service.contract.ContractService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Collections;
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

        Fleet fleet = request.fleetId() != null ? fleetRepository.findById(request.fleetId()).orElse(null) : null;

        // Si el usuario no tiene el rol de conductor de flota, se le asigna
        if (!userModel.getRoles().contains(UserRoles.DRIVER_FLEET) || !userModel.getRoles().contains(UserRoles.DRIVER_CHAUFFEUR)) {

            // Dependiendo de si el contrato es de flota o no, se le asigna el rol correspondiente
            if (fleet != null) {
                userModel.getRoles().add(UserRoles.DRIVER_FLEET);
                userModel.setDriverData(new FleetDriverModelData());

                FleetDriverModelData driverData = (FleetDriverModelData) userModel.getDriverData();
                driverData.setFleet(fleet);
            } else {
                userModel.getRoles().add(UserRoles.DRIVER_CHAUFFEUR);
                userModel.setDriverData(new ChauffeurDriverModelData());
            }
        }

        DriverContract prevContract = userModel.getDriverData().getActualContract();

        DriverContract contract = request.toDriverContract(
                userModel.getDriverData()
        );

        // Añadir el contrato al usuario
        DriverModelData driverData = userModel.getDriverData();
        driverData.getDriverContracts().add(contract);
        userModel.setDriverData(driverData);

        // Actualizar el usuario
        System.out.println("AAAAAAAAAAAAAAAAAAAAAA");
        userRepository.save(userModel);
        System.out.println("BBBBBBBBBBBBBBBBBBBBBB");
        contractRepository.save(contract);
        System.out.println("CCCCCCCCCCCCCCCCCCCCC");

        // Actualizar el contrato anterior
        if (prevContract != null) {
            prevContract.setNextContract(contract);
            contractRepository.save(prevContract);

            // Establecer en el contrato actual el contrato anterior para poder hacer la relación bidireccional
            contract.setPreviousContract(prevContract);
        }

        return contract;
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
        return /*contractRepository.findAllByFleetId(fleetId);*/ Collections.emptyList();
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
