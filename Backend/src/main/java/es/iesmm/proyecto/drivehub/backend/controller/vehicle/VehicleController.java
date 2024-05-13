package es.iesmm.proyecto.drivehub.backend.controller.vehicle;

import es.iesmm.proyecto.drivehub.backend.model.rent.vehicle.RentCar;
import es.iesmm.proyecto.drivehub.backend.model.ship.Shipment;
import es.iesmm.proyecto.drivehub.backend.service.vehicle.VehicleService;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/vehicle")
@AllArgsConstructor
public class VehicleController {

    private final VehicleService vehicleService;

    @GetMapping("/all")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN') and hasAuthority('LIST_ALL_VEHICLES')")
    public List<RentCar> listRentedVehicles() {
        return vehicleService.findAll();
    }

    @GetMapping("/{id}")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN') and hasAuthority('GET_VEHICLE')")
    public ResponseEntity<RentCar> getVehicleById(@PathVariable Long id) {
        return vehicleService.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN') and hasAuthority('CREATE_VEHICLE')")
    public ResponseEntity<RentCar> createVehicle(@RequestBody RentCar vehicle) {
        try {
            return ResponseEntity.ok(vehicleService.save(vehicle));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().build();
        } catch (IllegalStateException e) {
            return ResponseEntity.status(409).build();
        } catch (NullPointerException e) {
            return ResponseEntity.notFound().build();
        }
    }

    @PutMapping("/{id}")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN') and hasAuthority('UPDATE_VEHICLE')")
    public ResponseEntity<RentCar> updateVehicle(@PathVariable Long id, @RequestBody RentCar vehicle) {
        return vehicleService.findById(id)
                .map(v -> ResponseEntity.ok(vehicleService.save(vehicle)))
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN') and hasAuthority('DELETE_VEHICLE')")
    public ResponseEntity<Void> deleteVehicle(@PathVariable Long id) {
        try {
            vehicleService.deleteById(id);
            return ResponseEntity.ok().build();
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().build();
        } catch (IllegalStateException e) {
            return ResponseEntity.status(409).build();
        } catch (NullPointerException e) {
            return ResponseEntity.notFound().build();
        }
    }

}
