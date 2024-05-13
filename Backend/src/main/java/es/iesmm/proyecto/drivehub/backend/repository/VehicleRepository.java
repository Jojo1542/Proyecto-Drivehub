package es.iesmm.proyecto.drivehub.backend.repository;

import es.iesmm.proyecto.drivehub.backend.model.rent.vehicle.RentCar;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface VehicleRepository extends JpaRepository<RentCar, Long> {

    @Query("SELECT v FROM RentCar v WHERE v.plate = :plate")
    RentCar findByPlate(String plate);
}
