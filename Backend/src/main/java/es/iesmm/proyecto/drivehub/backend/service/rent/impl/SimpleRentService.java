package es.iesmm.proyecto.drivehub.backend.service.rent.impl;

import com.google.common.base.Preconditions;
import es.iesmm.proyecto.drivehub.backend.model.rent.history.UserRent;
import es.iesmm.proyecto.drivehub.backend.model.rent.history.key.UserRentKey;
import es.iesmm.proyecto.drivehub.backend.model.rent.vehicle.RentCar;
import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
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

    @Override
    public List<UserRent> findRentedVehiclesBy(UserModel userDetails) {
        return userDetails.getUserRent() != null ? userDetails.getUserRent() : Collections.emptyList();
    }

    @Override
    public RentCar rentVehicle(Long vehicleId, UserModel user) {
        // Comprobar que el vehículo existe, que el usuario existe y que el usuario no tiene un alquiler activo, si no, lanzar excepción
        Preconditions.checkNotNull(vehicleId, "Vehicle ID cannot be null");
        Preconditions.checkNotNull(user, "User cannot be null");
        Preconditions.checkState(user.hasRentActive(), "User has an active rent");

        Optional<RentCar> optionalVehicle = vehicleService.findById(vehicleId);
        RentCar vehicle = optionalVehicle.orElseThrow(() -> new NullPointerException("Vehicle not found"));

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
        Preconditions.checkState(!user.hasRentActive(), "User does not have an active rent");

        Optional<RentCar> optionalVehicle = vehicleService.findById(vehicleId);
        RentCar vehicle = optionalVehicle.orElseThrow(() -> new NullPointerException("Vehicle not found"));

        Collection<UserRent> userRents = user.getUserRent();
        // Obtiene el alquiler activo del usuario para el vehículo, si no lo encuentra, lanza una excepción
        UserRent userRent = userRents.stream()
                .filter(ur -> ur.getVehicle().equals(vehicle) && ur.isActive())
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("Vehicle not rented by user"));

        userRent.setActive(false);
        userRent.setEndTime(Timestamp.from(Instant.now()));

        // Get the hours the vehicle was rented (rounded up)
        long hours = (int) Math.ceil((userRent.getEndTime().getTime() - userRent.getStartTime().getTime()) / 3600000.0);
        userRent.setFinalPrice(vehicle.getPrecioHora() * hours);

        // Save the rent so the final price is updated
        rentRepository.save(userRent);
        return userRent;
    }

    @Override
    public List<UserRent> findAll() {
        return rentRepository.findAll();
    }
}
