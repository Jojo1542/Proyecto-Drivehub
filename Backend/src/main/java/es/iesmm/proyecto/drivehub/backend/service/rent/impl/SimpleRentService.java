package es.iesmm.proyecto.drivehub.backend.service.rent.impl;

import com.google.common.base.Preconditions;
import es.iesmm.proyecto.drivehub.backend.model.rent.history.UserRent;
import es.iesmm.proyecto.drivehub.backend.model.rent.history.key.UserRentKey;
import es.iesmm.proyecto.drivehub.backend.model.rent.vehicle.RentCar;
import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.license.type.DriverLicenseType;
import es.iesmm.proyecto.drivehub.backend.repository.RentRepository;
import es.iesmm.proyecto.drivehub.backend.repository.UserRepository;
import es.iesmm.proyecto.drivehub.backend.repository.VehicleRepository;
import es.iesmm.proyecto.drivehub.backend.service.rent.RentService;
import es.iesmm.proyecto.drivehub.backend.service.vehicle.VehicleService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.time.Instant;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

@Service
@AllArgsConstructor
public class SimpleRentService implements RentService {

    private final VehicleService vehicleService;
    private final RentRepository rentRepository;
    private final UserRepository userRepository;

    private final List<DriverLicenseType> validLicenseTypes = List.of(
            DriverLicenseType.B,
            DriverLicenseType.BE,
            DriverLicenseType.C,
            DriverLicenseType.CE
    );

    @Override
    public List<UserRent> findRentedVehiclesBy(UserModel userDetails) {
        return userDetails.getUserRent() != null ? userDetails.getUserRent() : Collections.emptyList();
    }

    @Override
    public RentCar rentVehicle(Long vehicleId, UserModel user) {
        // Comprobar que el vehículo existe, que el usuario existe y que el usuario no tiene un alquiler activo, si no, lanzar excepción
        Preconditions.checkNotNull(vehicleId, "Vehicle ID cannot be null");
        Preconditions.checkNotNull(user, "User cannot be null");
        Preconditions.checkState(!user.hasRentActive(), "USER_ALREADY_HAS_RENT");
        Preconditions.checkState(!hasValidDriverLicense(user), "USER_DOES_NOT_HAVE_LICENSE");

        RentCar vehicle = vehicleService.findById(vehicleId).orElseThrow(() -> new NullPointerException("VEHICLE_NOT_FOUND"));

        Preconditions.checkState(vehicle.isAvailable(), "VEHICLE_NOT_AVAILABLE");
        Preconditions.checkState(user.canAfford(vehicle.getPrecioHora()), "USER_CANT_AFFORD_RENT");

        UserRent userRent = UserRent
                .builder()
                .user(user)
                .vehicle(vehicle)
                .active(true)
                .startTime(Timestamp.from(Instant.now()))
                .build();

        userRent.generateKey();

        user.getUserRent().add(
                userRent
        );

        rentRepository.save(userRent);

        return vehicle;
    }

    @Override
    public UserRent returnVehicle(Long vehicleId, UserModel user) {
        // Comprobar que el vehículo existe, que el usuario existe y que el usuario tiene un alquiler activo, si no, lanzar excepción
        Preconditions.checkNotNull(vehicleId, "Vehicle ID cannot be null");
        Preconditions.checkNotNull(user, "User cannot be null");
        Preconditions.checkState(user.hasRentActive(), "USER_DOES_NOT_HAVE_ACTIVE_RENT");

        Optional<RentCar> optionalVehicle = vehicleService.findById(vehicleId);
        RentCar vehicle = optionalVehicle.orElseThrow(() -> new NullPointerException("VEHICLE_NOT_FOUND"));

        Collection<UserRent> userRents = user.getUserRent();
        // Obtiene el alquiler activo del usuario para el vehículo, si no lo encuentra, lanza una excepción
        UserRent userRent = userRents.stream()
                .filter(ur -> ur.getVehicle().equals(vehicle) && ur.isActive())
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("VEHICLE_NOT_RENTED_BY_USER"));

        userRent.setActive(false);
        userRent.setEndTime(Timestamp.from(Instant.now()));

        // Get the hours the vehicle was rented (rounded up)
        long hours = (int) Math.ceil((userRent.getEndTime().getTime() - userRent.getStartTime().getTime()) / 3600000.0);
        userRent.setFinalPrice(vehicle.getPrecioHora() * hours);

        // Save the rent so the final price is updated
        rentRepository.save(userRent);

        // Remover el saldo del alquiler del usuario
        user.setSaldo(user.getSaldo() - userRent.getFinalPrice());

        // Guardar el usuario para actualizar el saldo (El saldo puede ser negativo, en cuyo caso no se permitirá alquilar vehículos)
        userRepository.save(user);

        return userRent;
    }

    @Override
    public List<UserRent> findAll() {
        return rentRepository.findAll();
    }

    @Override
    public Optional<UserRent> findActiveRentBy(UserModel userDetails) {
        return userDetails.getUserRent().stream()
                .filter(UserRent::isActive)
                .findFirst();
    }

    private boolean hasValidDriverLicense(UserModel user) {
        return user.getDriverLicenses().stream().anyMatch(dl -> validLicenseTypes.contains(dl.getType()));
    }
}
