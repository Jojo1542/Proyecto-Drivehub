package es.iesmm.proyecto.drivehub.backend.service.vehicle.impl;

import com.google.common.base.Preconditions;
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

    @Override
    public Optional<RentCar> findByPlate(String plate) {
        return vehicleRepository.findByPlate(plate);
    }

    @Override
    public Optional<RentCar> findByNumBastidor(String numBastidor) {
        return vehicleRepository.findByNumBastidor(numBastidor);
    }

    @Override
    public RentCar save(RentCar vehicle) {
        // Control de errores y validaciones de los datos
        Preconditions.checkNotNull(vehicle, "The vehicle cannot be null");
        Preconditions.checkState(findByPlate(vehicle.getPlate()).isEmpty(), "The vehicle with plate " + vehicle.getPlate() + " already exists");
        Preconditions.checkState(findByNumBastidor(vehicle.getNumBastidor()).isEmpty(), "The vehicle with numBastidor " + vehicle.getNumBastidor() + " already exists");

        return vehicleRepository.save(vehicle);
    }

    @Override
    public RentCar updateById(Long id, RentCar vehicle) {
        Preconditions.checkNotNull(vehicle, "The vehicle cannot be null");

        Optional<RentCar> vehicleOptional = findById(id);

        Preconditions.checkState(vehicleOptional.isPresent(), "The vehicle with id " + id + " does not exist");

        RentCar vehicleToUpdate = vehicleOptional.get();

        vehicleToUpdate.setBrand(vehicle.getBrand());
        vehicleToUpdate.setModel(vehicle.getModel());
        vehicleToUpdate.setColor(vehicle.getColor());
        vehicleToUpdate.setFechaMatriculacion(vehicle.getFechaMatriculacion());
        vehicleToUpdate.setImageUrl(vehicle.getImageUrl());
        vehicleToUpdate.setPrecioHora(vehicle.getPrecioHora());

        return vehicleRepository.save(vehicleToUpdate);
    }

    @Override
    public void deleteById(Long id) {
        // Control de errores y validaciones de los datos
        Preconditions.checkNotNull(id, "The id cannot be null");
        Preconditions.checkArgument(vehicleRepository.existsById(id), "The vehicle with id " + id + " does not exist");

        vehicleRepository.deleteById(id);
    }
}
