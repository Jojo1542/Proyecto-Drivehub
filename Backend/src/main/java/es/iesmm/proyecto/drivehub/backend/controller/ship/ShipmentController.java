package es.iesmm.proyecto.drivehub.backend.controller.ship;

import es.iesmm.proyecto.drivehub.backend.model.http.request.ship.ShipmentCreationRequest;
import es.iesmm.proyecto.drivehub.backend.model.http.request.ship.ShipmentStatusUpdateRequest;
import es.iesmm.proyecto.drivehub.backend.model.ship.Shipment;
import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import es.iesmm.proyecto.drivehub.backend.model.user.location.UserLocation;
import es.iesmm.proyecto.drivehub.backend.service.location.LocationService;
import es.iesmm.proyecto.drivehub.backend.service.ship.ShipmentService;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ProblemDetail;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.access.annotation.Secured;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import static es.iesmm.proyecto.drivehub.backend.util.permission.PermissionUtils.hasAdminPermission;
import static es.iesmm.proyecto.drivehub.backend.util.permission.PermissionUtils.hasFleetPermission;

@RestController
@RequestMapping("/ship")
@AllArgsConstructor
public class ShipmentController {

    private final ShipmentService shipmentService;
    private final LocationService locationService;

    @GetMapping("/{id}")
    @ResponseBody
    public ResponseEntity<Shipment> getShipmentById(@PathVariable Long id) {
        return shipmentService.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/{id}/location")
    @ResponseBody
    public ResponseEntity<UserLocation> getShipmentLocationById(@PathVariable Long id) {
        return shipmentService.findById(id)
                .map(shipment -> locationService.findLatestLocation(shipment.getDriver().getId())
                        .map(ResponseEntity::ok)
                        .orElse(ResponseEntity.notFound().build()))
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/all")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN') and (hasAuthority('LIST_ALL_SHIPMENTS') or hasAuthority('SUPER_ADMIN'))")
    public List<Shipment> listAllShipments() {
        return shipmentService.findAll();
    }

    @GetMapping("/listOwn")
    @ResponseBody
    @PreAuthorize("hasRole('DRIVER_FLEET')")
    public ResponseEntity<List<Shipment>> listOwnShipments(@AuthenticationPrincipal UserDetails userDetails) {
        return ResponseEntity.ok(shipmentService.findByDriver((UserModel) userDetails));
    }

    @GetMapping("/list/fleet/{fleetId}")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<Shipment>> listFleetShipments(@PathVariable Long fleetId, @AuthenticationPrincipal UserDetails userDetails) {
        UserModel user = (UserModel) userDetails;

        if (hasFleetPermission(user, fleetId) || hasAdminPermission(user, "SUPER_ADMIN")) {
            return ResponseEntity.ok(shipmentService.findByFleet(fleetId));
        } else {
            throw new AccessDeniedException("User does not have the required role");
        }
    }

    @PostMapping("/create")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN') and hasAuthority('CREATE_SHIPMENT')")
    public ResponseEntity<Shipment> createShipment(@RequestBody ShipmentCreationRequest request) {
        try {
            return ResponseEntity.ok(shipmentService.createShipment(request));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.of(ProblemDetail.forStatusAndDetail(HttpStatus.BAD_REQUEST, e.getMessage())).build();
        } catch (IllegalStateException e) {
            return ResponseEntity.of(ProblemDetail.forStatusAndDetail(HttpStatus.CONFLICT, e.getMessage())).build();
        } catch (Exception e) {
            return ResponseEntity.of(ProblemDetail.forStatusAndDetail(HttpStatus.INTERNAL_SERVER_ERROR, e.getMessage())).build();
        }
    }

    @PutMapping("/status/{id}")
    @ResponseBody
    @PreAuthorize("(hasRole('ADMIN') and hasAuthority('UPDATE_SHIPMENT')) or hasRole('DRIVER_FLEET')")
    public ResponseEntity<Shipment> updateShipmentStatus(@PathVariable Long id, @RequestBody ShipmentStatusUpdateRequest request) {
        return shipmentService.findById(id)
                .map(s -> ResponseEntity.ok(shipmentService.updateStatus(s, request)))
                .orElse(ResponseEntity.notFound().build());
    }

    @PutMapping("/{id}")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN') and hasAuthority('UPDATE_SHIPMENT')")
    public ResponseEntity<Shipment> updateShipment(@PathVariable Long id, @RequestBody Shipment shipment) {
        return shipmentService.findById(id)
                .map(s -> ResponseEntity.ok(shipmentService.update(s, shipment)))
                .orElse(ResponseEntity.notFound().build());
    }


    @DeleteMapping("/{id}")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN') and hasAuthority('DELETE_SHIPMENT')")
    public ResponseEntity<Object> deleteShipment(@PathVariable Long id) {
        return shipmentService.findById(id)
                .map(s -> {
                    shipmentService.deleteById(id);
                    return ResponseEntity.ok().build();
                })
                .orElse(ResponseEntity.notFound().build());
    }

}
