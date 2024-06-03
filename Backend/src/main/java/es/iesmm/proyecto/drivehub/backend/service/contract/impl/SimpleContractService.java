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

import java.util.*;

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

        // Se comprueba si el contrato es de flota o de chofer, si es de flota, se obtiene, si no se encuentra
        // se lanza una excepción
        Fleet fleet = request.fleetId() != null ? fleetRepository.findById(request.fleetId())
                .orElseThrow(() -> new IllegalArgumentException("Fleet specified can not be found"))
                : null;

        // Se comprueba si el usuario ya es conductor de flota o de chofer, si no lo es, se le añade el rol
        if (fleet != null) {
            if (!userModel.getRoles().contains(UserRoles.DRIVER_FLEET)) {
                userModel.getRoles().add(UserRoles.DRIVER_FLEET);
                userModel.getRoles().remove(UserRoles.DRIVER_CHAUFFEUR);
                userModel.setDriverData(new FleetDriverModelData());
            }
        } else {
            if (!userModel.getRoles().contains(UserRoles.DRIVER_CHAUFFEUR)) {
                userModel.getRoles().add(UserRoles.DRIVER_CHAUFFEUR);
                userModel.getRoles().remove(UserRoles.DRIVER_FLEET);
                userModel.setDriverData(new ChauffeurDriverModelData());
            }
        }

        // Se añade el contrato al usuario y se guarda
        DriverModelData driverData = userModel.getDriverData();
        DriverContract contract = request.toDriverContract(userModel);

        // Si el contrato es de flota, se le asigna la flota correspondiente
        if (fleet != null) {
            contract.setFleet(fleet);

            // Se asigna la flota al usuario
            FleetDriverModelData fleetDriverModelData = (FleetDriverModelData) driverData;
            fleetDriverModelData.setFleet(fleet);
        }

        DriverContract savedContract = contractRepository.save(contract);

        // Se obtiene el contrato actual del usuario
        findByDriver(userModel)
                .stream()
                .filter(other -> !other.isExpired()) // Comprobar que no ha expirado
                .filter(other -> !Objects.equals(other.getId(), savedContract.getId()))
                .max(Comparator.comparing(DriverContract::getEndDate))
                // Se filtra para que no sea el mismo contrato por su ID
                .ifPresent(actualContract -> {
                    // Se establece la fecha de fin del contrato anterior
                    actualContract.setEndDate(savedContract.getStartDate());

                    // Se establece este contrato como el actual
                    actualContract.setNextContract(savedContract);

                    // Se establece el contrato anterior como el anterior de este contrato
                    savedContract.setPreviousContract(actualContract);

                    // Se actualiza el contrato anterior en la base de datos
                    contractRepository.save(actualContract);
                });

        // Se guarda el usuario en la base de datos
        userRepository.save(userModel);

        // Se guarda el contrato en la base de datos
        return contractRepository.save(savedContract);
    }

    @Override
    public Optional<DriverContract> getActualContract(UserModel user) {
        DriverModelData driverData = user.getDriverData();
        if (driverData == null) {
            return Optional.empty();
        }
        // Obtener el contrato con fecha de finalización mas reciente
        return findByDriver(user)
                .stream()
                .filter(contract -> !contract.isExpired()) // Comprobar que no ha expirado
                .max(Comparator.comparing(DriverContract::getEndDate));
    }

    @Override
    public List<DriverContract> findByDriver(UserModel user) {
        DriverModelData driverData = user.getDriverData();
        if (driverData == null) {
            return Collections.emptyList();
        }
        return contractRepository.findByDriver(user.getId());
    }

    @Override
    public List<DriverContract> findAll() {
        return contractRepository.findAll();
    }

    @Override
    public List<DriverContract> findAllGeneral() {
        return contractRepository.findAllGeneral();
    }

    @Override
    public List<DriverContract> findAllByFleet(Long fleetId) {
        return contractRepository.findAllByFleet(fleetId);
    }

    @Override
    public Optional<DriverContract> findById(Long contractId) {
        return contractRepository.findById(contractId);
    }

    @Override
    public Optional<DriverContract> findGeneralById(Long contractId) {
        return contractRepository.findGeneralById(contractId);
    }

    @Override
    public Optional<DriverContract> findContractByIdFleet(Long driverId, Long fleetId) {
        return contractRepository.findContractByIdFleet(driverId, fleetId);
    }

    @Override
    public void deleteById(Long contractId) {
        contractRepository.deleteById(contractId);
    }

    @Override
    public void finalizeContract(Long contractId) {
        DriverContract contract = contractRepository.findById(contractId)
                .orElseThrow(() -> new IllegalArgumentException("Contract not found"));

        // Check if contract is active
        Preconditions.checkState(!contract.isExpired(), "Contract is already finalized");

        // Actualizar la fecha de finalización del contrato
        contract.setEndDate(new Date());

        // Guardar el contrato en la base de datos
        contractRepository.save(contract);

        // Actualizar el usuario y eliminarle el rol de conductor
        UserModel driver = contract.getDriver();
        driver.getRoles().remove(UserRoles.DRIVER_FLEET);
        driver.getRoles().remove(UserRoles.DRIVER_CHAUFFEUR);

        // Guardar el usuario en la base de datos
        userRepository.save(driver);
    }
}
