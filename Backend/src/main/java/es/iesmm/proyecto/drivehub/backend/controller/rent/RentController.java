package es.iesmm.proyecto.drivehub.backend.controller.rent;

import es.iesmm.proyecto.drivehub.backend.model.rent.history.UserRent;
import es.iesmm.proyecto.drivehub.backend.model.rent.vehicle.RentCar;
import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import es.iesmm.proyecto.drivehub.backend.service.rent.RentService;
import es.iesmm.proyecto.drivehub.backend.service.vehicle.VehicleService;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/rent")
@AllArgsConstructor
public class RentController {

    private final RentService rentService;
    private final VehicleService vehicleService;

    @GetMapping("/available")
    @ResponseBody
    public List<RentCar> listAvailableVehicles() {
        return vehicleService.findAvailableVehicles();
    }

    @GetMapping("/rentedByMe")
    @ResponseBody
    public List<UserRent> listRentedVehiclesByMe(@AuthenticationPrincipal UserDetails userDetails) {
        return rentService.findRentedVehiclesBy((UserModel) userDetails);
    }

    @PostMapping("/take/{vehicleId}")
    @ResponseBody
    public ResponseEntity<RentCar> rentVehicle(@PathVariable Long vehicleId, @AuthenticationPrincipal UserDetails userDetails) {
        try {
            return ResponseEntity.ok(
                    rentService.rentVehicle(vehicleId, (UserModel) userDetails)
            );
        } catch (NullPointerException e) {
            return ResponseEntity.notFound().build();
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().build();
        } catch (IllegalStateException e) {
            return ResponseEntity.status(409).build();
        }
    }

    @PostMapping("/return/{vehicleId}")
    @ResponseBody
    public ResponseEntity<UserRent> returnVehicle(@PathVariable Long vehicleId, @AuthenticationPrincipal UserDetails userDetails) {
        try {
            return ResponseEntity.ok(
                    rentService.returnVehicle(vehicleId, (UserModel) userDetails)
            );
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().build();
        } catch (IllegalStateException e) {
            return ResponseEntity.status(406).build();
        }
    }

    /*
    Metodos que requieren de un rol
     */

    @GetMapping("/allRents")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN') and hasAuthority('LIST_ALL_RENTS')")
    public List<UserRent> listAllRents() {
        return rentService.findAll();
    }



}
