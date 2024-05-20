package es.iesmm.proyecto.drivehub.backend.service.rent;

import es.iesmm.proyecto.drivehub.backend.model.rent.history.UserRent;
import es.iesmm.proyecto.drivehub.backend.model.rent.vehicle.RentCar;
import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;

import java.util.List;

public interface RentService {

    List<UserRent> findRentedVehiclesBy(UserModel userDetails);

    RentCar rentVehicle(Long vehicleId, UserModel userDetails);

    UserRent returnVehicle(Long vehicleId, UserModel userDetails);

    List<UserRent> findAll();
}
