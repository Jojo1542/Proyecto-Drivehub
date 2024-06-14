package es.iesmm.proyecto.drivehub.backend.service.fleet.impl;

import com.google.common.base.Preconditions;
import es.iesmm.proyecto.drivehub.backend.model.fleet.Fleet;
import es.iesmm.proyecto.drivehub.backend.model.http.request.fleet.FleetCreationRequest;
import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import es.iesmm.proyecto.drivehub.backend.model.user.admin.AdminModelData;
import es.iesmm.proyecto.drivehub.backend.model.user.admin.permisison.AdminPermission;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.DriverModelData;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.contract.DriverContract;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.fleet.FleetDriverModelData;
import es.iesmm.proyecto.drivehub.backend.repository.FleetRepository;
import es.iesmm.proyecto.drivehub.backend.repository.UserRepository;
import es.iesmm.proyecto.drivehub.backend.service.fleet.FleetService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.LinkedList;
import java.util.List;
import java.util.Optional;

@Service
@AllArgsConstructor
public class SimpleFleetService implements FleetService {

    private final FleetRepository fleetRepository;
    private final UserRepository userRepository;

    @Override
    public List<Fleet> findAll() {
        return fleetRepository.findAll();
    }

    @Override
    public Optional<Fleet> findById(Long fleetId) {
        return fleetRepository.findById(fleetId);
    }

    @Override
    public Optional<Fleet> findByDriver(UserModel user) {
        Optional<Fleet> fleet = Optional.empty();

        // Se obtiene el modelo de datos del conductor, si es de flota, se obtiene la flota,
        DriverModelData driver = user.getDriverData();
        if (driver instanceof FleetDriverModelData fleetModelData) {
            fleet = Optional.of(fleetModelData.getFleet());
        }

        return fleet;
    }

    @Override
    public Fleet createFleet(UserModel userDetails, FleetCreationRequest request) {
        Preconditions.checkNotNull(userDetails, "User cannot be null");
        Preconditions.checkNotNull(request, "Request cannot be null");
        // Se comprueba que no exista una flota con el mismo CIF
        Preconditions.checkArgument(findByCIF(request.CIF()).isEmpty(), "CIF_ALREADY_EXISTS");

        // Se crea la flota y se guarda
        Fleet fleet = fleetRepository.save(request.toFleet());

        // Se añade el permiso de administrador a la flota
        AdminModelData admin = userDetails.getAdminData();
        admin.addFleetPermission(fleet);

        userRepository.save(userDetails);
        return fleet;
    }

    @Override
    public Fleet updateById(Long fleetId, Fleet request) {
        Preconditions.checkNotNull(fleetId, "Fleet ID cannot be null");
        Preconditions.checkNotNull(request, "Request cannot be null");

        // Se obtiene la flota y se comprueba que exista, si no existe se lanza una excepción
        Fleet fleet = fleetRepository.findById(fleetId).orElseThrow(() -> new IllegalArgumentException("Fleet does not exist"));

        // Se actualizan los datos de la flota
        fleet.setName(request.getName());
        fleet.setVehicleType(request.getVehicleType());

        return fleetRepository.save(fleet);
    }

    @Override
    public void deleteById(Long fleetId) {
        Preconditions.checkNotNull(fleetId, "Fleet ID cannot be null");
        Preconditions.checkArgument(fleetRepository.existsById(fleetId), "Fleet does not exist");

        fleetRepository.deleteById(fleetId);
    }

    public Optional<Fleet> findByCIF(String CIF) {
        return fleetRepository.findByCIF(CIF);
    }

    @Override
    public List<Fleet> findByAdmin(UserModel user) {
        AdminModelData admin = user.getAdminData();

        List<Fleet> fleets = new LinkedList<>();

        // Dependiendo de los permisos del administrador, se obtienen todas las flotas o solo las que tiene acceso
        if (admin.hasGeneralPermission(AdminPermission.SUPER_ADMIN)) {
            fleets = fleetRepository.findAll();
        } else {
            // Se recorren las flotas a las que tiene acceso el administrador
            for (Long fleetRole : admin.getFleetPermissions()) {
                // Se obtiene la flota
                Fleet fleet = fleetRepository.findById(fleetRole).orElse(null);

                // Si la flota existe (Debería existir si o si, pero controlo el error por si acaso), se añade a la lista
                if (fleet != null) {
                    fleets.add(fleet);
                }
            }
        }

        return fleets;
    }
}
