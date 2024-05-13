package es.iesmm.proyecto.drivehub.backend.service.vehicle.impl;

import es.iesmm.proyecto.drivehub.backend.model.rent.vehicle.RentCar;
import es.iesmm.proyecto.drivehub.backend.repository.VehicleRepository;
import es.iesmm.proyecto.drivehub.backend.service.vehicle.VehicleService;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@AllArgsConstructor
public class SimpleVehicleService implements VehicleService {

    private final VehicleRepository vehicleRepository;

    @Override
    public List<RentCar> findAvailableVehicles() {
        return findAll().stream().filter(RentCar::isAvailable).toList();
    }

    @Override
    public List<RentCar> findAll() {
        return vehicleRepository.findAll();
    }

    @Override
    public Optional<RentCar> findById(Long vehicleId) {
        return vehicleRepository.findById(vehicleId);
    }
}
