package es.iesmm.proyecto.drivehub.backend.service.user.impl;

import es.iesmm.proyecto.drivehub.backend.model.http.request.user.DriverModificationRequest;
import es.iesmm.proyecto.drivehub.backend.model.http.request.user.UserModificationRequest;
import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import es.iesmm.proyecto.drivehub.backend.model.user.admin.AdminModelData;
import es.iesmm.proyecto.drivehub.backend.model.user.admin.permisison.AdminPermission;
import es.iesmm.proyecto.drivehub.backend.model.user.balance.type.BalanceChangeType;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.fleet.FleetDriverModelData;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.license.DriverLicense;
import es.iesmm.proyecto.drivehub.backend.model.user.roles.UserRoles;
import es.iesmm.proyecto.drivehub.backend.repository.UserRepository;
import es.iesmm.proyecto.drivehub.backend.service.user.UserService;
import lombok.AllArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@AllArgsConstructor
public class SimpleUserService implements UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public UserModel save(UserModel userModel) {
        return userRepository.save(userModel);
    }

    @Override
    public Optional<UserModel> findByEmail(String email) {
        return Optional.ofNullable(userRepository.findByEmail(email));
    }

    @Override
    public Optional<UserModel> findByDNI(String DNI) {
        return Optional.ofNullable(userRepository.findByDNI(DNI));
    }

    @Override
    public Optional<UserModel> findById(Long id) {
        return userRepository.findById(id);
    }

    @Override
    public void delete(UserModel userModel) {
        userRepository.delete(userModel);
    }

    @Override
    public void deleteById(Long id) {
        userRepository.deleteById(id);
    }

    @Override
    public boolean existsByEmail(String email) {
        return findByEmail(email).isPresent();
    }

    @Override
    public boolean existsById(Long id) {
        return findById(id).isPresent();
    }

    @Override
    public long count() {
        return userRepository.count();
    }

    @Override
    public List<UserModel> findAll() {
        return userRepository.findAll();
    }

    @Override
    public Page<UserModel> findAllPaged(Pageable pageable) {
        return userRepository.findAll(pageable);
    }

    @Override
    public void updateUserByRequest(UserModel user, UserModificationRequest request) {
        // Si el email es nulo o no existe en la base de datos, se permite la modificación (ya que no se está cambiando el email o el email no está en uso)
        if (request.email() == null || user.getEmail().equalsIgnoreCase(request.email()) || findByEmail(request.email().toLowerCase()).isEmpty()) {
            // Si el DNI es nulo se permite la modificación, también se comprueba que no esté en uso
            if (request.dni() == null || findByDNI(request.dni()).isEmpty()) {

                // Si el DNI de la petición y el DNI del usuario son nulos, se permite la modificación,
                if (request.dni() == null || user.getDNI() == null || user.getDNI().equals(request.dni())) {
                    // Aplica los cambios de la petición al usuario especificado, vamos el usuario autenticado
                    request.applyToUser(user);

                    // Si tiene contraseña, se codifica y se guarda
                    if (request.password() != null) {
                        user.setPassword(passwordEncoder.encode(request.password()));
                    }

                    // Guarda los cambios en la base de datos
                    save(user);
                } else {
                    throw new IllegalArgumentException("No se puede cambiar el DNI de un usuario - CANNOT_CHANGE_DNI");
                }
            } else {
                throw new IllegalArgumentException("El DNI ya esta en uso - DNI_ALREADY_IN_USE");
            }
        } else {
            throw new IllegalArgumentException("El email ya esta en uso - EMAIL_ALREADY_IN_USE");
        }
    }

    @Override
    public void updateDriverByRequest(UserModel user, DriverModificationRequest request) {
        request.applyToUser(user);
        save(user);
    }

    @Override
    public void updateAdminPermissions(Long id, List<String> permissions) {
        UserModel user = findById(id).orElseThrow(() -> new IllegalArgumentException("USER_NOT_FOUND"));

        // Comprobar si el usuario es administrador, si no lo es, lanzar una excepción
        if (user.getAdminData() == null) {
            throw new IllegalStateException("USER_IS_NOT_ADMIN");
        }

        // Obtener los datos de administrador del usuario
        AdminModelData adminData = user.getAdminData();

        // Convertir los permisos de String a AdminPermission
        List<AdminPermission> adminPermissions = permissions.stream()
                .map(AdminPermission::valueOf)
                .toList();

        // Establecer los permisos generales del administrador
        adminData.setGeneralPermissions(adminPermissions);
        save(user); // Guardar los cambios en la base de datos
    }

    @Override
    public void updateUserBalance(Long id, double amount, BalanceChangeType type) {
        UserModel user = findById(id).orElseThrow(() -> new IllegalArgumentException("USER_NOT_FOUND"));

        // Realizar el cambio de saldo
        if (type == BalanceChangeType.DEPOSIT) {
            // Depositar el saldo
            user.deposit(amount);
        } else if (type == BalanceChangeType.WITHDRAW) {
            // Retirar el saldo
            if (user.canAfford(amount)) {
                user.withdraw(amount);
            } else {
                // Si el usuario no puede pagar la cantidad, lanzar una excepción para indicar que no puede pagar
                throw new IllegalStateException("USER_CANNOT_AFFORD_AMOUNT");
            }
        }

        save(user);
    }

    @Override
    public void updateUserByAdmin(Long ip, UserModel request) {
        if (findById(ip).isPresent()) {
            save(request);
        } else {
            throw new IllegalArgumentException("El usuario no existe");
        }
    }

    @Override
    public void createDefaultUser(String defaultAdminEmail, String password) {
        UserModel userModel = new UserModel(defaultAdminEmail, passwordEncoder.encode(password), "Administrador", "Administrador");
        userModel.setRoles(List.of(UserRoles.USER, UserRoles.ADMIN));

        // Crear los datos por defecto del administrador
        AdminModelData adminData = new AdminModelData();
        adminData.giveAllPermissions(); // Dar todos los permisos al administrador

        // Establecer los datos de administrador
        userModel.setAdminData(adminData);
        adminData.setUserModel(userModel);

        save(userModel); // Guardar el usuario en la base de datos
    }

    @Override
    public List<UserModel> findDriversByFleet(Long fleetId) {
        return userRepository.findAll().stream()
                // Filtrar por los conductores
                .filter(user -> user.getDriverData() != null)
                // Filtrar que el conductor sea de flota
                .filter(user -> user.getDriverData() instanceof FleetDriverModelData)
                // Filtrar por la flota
                .filter(user -> {
                    FleetDriverModelData driverData = (FleetDriverModelData) user.getDriverData();
                    return driverData.getFleet() != null && Objects.equals(driverData.getFleet().getId(), fleetId);
                })
                // Meter en una lista
                .collect(Collectors.toList());
    }

    @Override
    public List<DriverLicense> findDriverLicensesByDriver(Long driverId) {
        UserModel user = findById(driverId).orElseThrow(() -> new IllegalArgumentException("USER_NOT_FOUND"));

        return user.getDriverLicenses().stream().toList();
    }

    @Override
    public void addDriverLicenseToDriver(Long driverId, DriverLicense license) {
        UserModel user = findById(driverId).orElseThrow(() -> new IllegalArgumentException("USER_NOT_FOUND"));

        license.setUser(user);
        user.getDriverLicenses().add(license);

        save(user);
    }

    @Override
    public void removeDriverLicenseFromDriver(Long driverId, String licenseId) {
        UserModel user = findById(driverId).orElseThrow(() -> new IllegalArgumentException("USER_NOT_FOUND"));

        DriverLicense license = user.getDriverLicenses().stream()
                // Filtrar por la licencia de conducir
                .filter(dl -> dl.getLicenseNumber().equals(licenseId))
                .findFirst()
                .orElseThrow(() -> new IllegalStateException("LICENSE_NOT_FOUND"));

        user.getDriverLicenses().remove(license);
        save(user);
    }
}
