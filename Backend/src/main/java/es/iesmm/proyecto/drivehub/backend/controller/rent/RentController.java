package es.iesmm.proyecto.drivehub.backend.controller.rent;

import es.iesmm.proyecto.drivehub.backend.model.rent.history.UserRent;
import es.iesmm.proyecto.drivehub.backend.model.rent.vehicle.RentCar;
import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import es.iesmm.proyecto.drivehub.backend.service.rent.RentService;
import es.iesmm.proyecto.drivehub.backend.service.user.UserService;
import es.iesmm.proyecto.drivehub.backend.service.vehicle.VehicleService;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ProblemDetail;
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
    private final UserService userService;

    @GetMapping("/available")
    @ResponseBody
    public List<RentCar> listAvailableVehicles() {
        return vehicleService.findAvailableVehicles();
    }

    @GetMapping("/active")
    @ResponseBody
    public ResponseEntity<UserRent> getActiveRent(@AuthenticationPrincipal UserDetails userDetails) {
        return rentService.findActiveRentBy((UserModel) userDetails)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }


    @GetMapping("/history")
    @ResponseBody
    public List<UserRent> listRentedVehiclesByMe(@AuthenticationPrincipal UserDetails userDetails) {
        return rentService.findRentedVehiclesBy((UserModel) userDetails);
    }

    @GetMapping("/history/{userId}")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN') and hasAuthority('LIST_RENTS_BY_USER')")
    public ResponseEntity<List<UserRent>> listRentedVehiclesByUser(@PathVariable Long userId) {
        return userService.findById(userId)
                .map(rentService::findRentedVehiclesBy)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
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
            return ResponseEntity.of(ProblemDetail.forStatusAndDetail(HttpStatus.BAD_REQUEST, e.getMessage())).build();
        } catch (IllegalStateException e) {
            return ResponseEntity.of(ProblemDetail.forStatusAndDetail(HttpStatus.CONFLICT, e.getMessage())).build();
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
            return ResponseEntity.of(ProblemDetail.forStatusAndDetail(HttpStatus.BAD_REQUEST, e.getMessage())).build();
        } catch (IllegalStateException e) {
            return ResponseEntity.of(ProblemDetail.forStatusAndDetail(HttpStatus.CONFLICT, e.getMessage())).build();
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
