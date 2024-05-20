package es.iesmm.proyecto.drivehub.backend.repository;

import es.iesmm.proyecto.drivehub.backend.model.rent.history.UserRent;
import es.iesmm.proyecto.drivehub.backend.model.rent.vehicle.RentCar;
import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RentRepository extends JpaRepository<UserRent, Long> {

    @Query("SELECT r FROM UserRent r WHERE r.user = :user")
    List<UserRent> findByUser(UserModel user);

    @Query("SELECT r FROM UserRent r WHERE r.vehicle = :vehicle")
    List<UserRent> findByVehicle(RentCar vehicle);
}
