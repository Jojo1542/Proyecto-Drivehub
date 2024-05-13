package es.iesmm.proyecto.drivehub.backend.controller.fleet;

import es.iesmm.proyecto.drivehub.backend.model.fleet.Fleet;
import es.iesmm.proyecto.drivehub.backend.model.http.request.fleet.FleetCreationRequest;
import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.contract.DriverContract;
import es.iesmm.proyecto.drivehub.backend.service.fleet.FleetService;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ProblemDetail;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/fleet")
@AllArgsConstructor
public class FleetController {

    private final FleetService fleetService;

    @GetMapping("/all")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN') and hasAuthority('SUPER_ADMIN')")
    public List<Fleet> listAllFleets() {
        return fleetService.findAll();
    }

    @GetMapping("/{fleetId}")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Fleet> getFleetById(@PathVariable Long fleetId, @AuthenticationPrincipal UserDetails userDetails) {
        // Check if the user has the FLEET_fleetId role
        if (userDetails.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("FLEET_" + fleetId))) {
            return fleetService.findById(fleetId)
                    .map(ResponseEntity::ok)
                    .orElse(ResponseEntity.notFound().build());
        } else {
            throw new AccessDeniedException("User does not have the required role");
        }
    }

    @GetMapping("/own")
    @ResponseBody
    @PreAuthorize("hasAnyRole('DRIVER_FLEET', 'DRIVER_CHAUFFEUR')")
    public ResponseEntity<Fleet> getFleetsThatHasAccess(@AuthenticationPrincipal UserDetails userDetails) {
        return fleetService.findByDriver((UserModel) userDetails)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/own/asAdmin")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN')")
    public List<Fleet> getFleetsThatHasAccessAsAdmin(@AuthenticationPrincipal UserDetails userDetails) {
        return fleetService.findByAdmin((UserModel) userDetails);
    }

    @PostMapping("/create")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN') and hasAuthority('CREATE_FLEET')")
    public ResponseEntity<Fleet> createFleet(@RequestBody FleetCreationRequest request, @AuthenticationPrincipal UserDetails userDetails) {
        try {
            return ResponseEntity.ok(fleetService.createFleet((UserModel) userDetails, request));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.of(ProblemDetail.forStatusAndDetail(HttpStatus.BAD_REQUEST, e.getMessage())).build();
        } catch (IllegalStateException e) {
            return ResponseEntity.of(ProblemDetail.forStatusAndDetail(HttpStatus.CONFLICT, e.getMessage())).build();
        } catch (Exception e) {
            return ResponseEntity.of(ProblemDetail.forStatusAndDetail(HttpStatus.INTERNAL_SERVER_ERROR, e.getMessage())).build();
        }
    }

    @PutMapping("/{fleetId}")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN') and hasAuthority('UPDATE_FLEET')")
    public ResponseEntity<Fleet> updateFleet(@PathVariable Long fleetId, @RequestBody Fleet request, @AuthenticationPrincipal UserDetails userDetails) {
        // Check if the user has the FLEET_fleetId role
        if (userDetails.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("FLEET_" + fleetId))) {
            return fleetService.findById(fleetId)
                    .map(f -> ResponseEntity.ok(fleetService.updateById(fleetId, request)))
                    .orElse(ResponseEntity.notFound().build());
        } else {
            throw new AccessDeniedException("User does not have the required role");
        }
    }

    @DeleteMapping("/{fleetId}")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN') and hasAuthority('DELETE_FLEET')")
    public ResponseEntity<Void> deleteFleet(@PathVariable Long fleetId) {
        try {
            fleetService.deleteById(fleetId);
            return ResponseEntity.ok().build();
        } catch (IllegalArgumentException e) {
            return ResponseEntity.notFound().build();
        } catch (IllegalStateException e) {
            return ResponseEntity.of(ProblemDetail.forStatusAndDetail(HttpStatus.CONFLICT, e.getMessage())).build();
        }
    }
}
