package es.iesmm.proyecto.drivehub.backend.controller.contract;

import es.iesmm.proyecto.drivehub.backend.model.http.request.contract.ContractCreationRequest;
import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.contract.DriverContract;
import es.iesmm.proyecto.drivehub.backend.service.contract.ContractService;
import es.iesmm.proyecto.drivehub.backend.service.fleet.FleetService;
import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/contract")
@AllArgsConstructor
public class ContractController {

    private final ContractService contractService;
    private final FleetService fleetService;

    @GetMapping("/own")
    @ResponseBody
    @PreAuthorize("hasAnyRole('DRIVER_FLEET', 'DRIVER_CHAUFFEUR')")
    public List<DriverContract> getOwnContracts(@AuthenticationPrincipal UserDetails userDetails) {
        return contractService.findAllByDriver((UserModel) userDetails);
    }

    @GetMapping("/all/{fleetId}")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<DriverContract>> listFleetContracts(@PathVariable Long fleetId, @AuthenticationPrincipal UserDetails userDetails) {
        // Check if the user has the FLEET_fleetId role
        if (userDetails.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("FLEET_" + fleetId) || a.getAuthority().equals("SUPER_ADMIN"))) {
            return fleetService.findById(fleetId)
                    .map(fleet -> ResponseEntity.ok(contractService.findAllByFleet(fleetId)))
                    .orElse(ResponseEntity.notFound().build());
        } else {
            throw new AccessDeniedException("User does not have the required role");
        }
    }

    @GetMapping("/all")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN') and hasAuthority('SUPER_ADMIN')")
    public List<DriverContract> listAllContracts() {
        return contractService.findAll();
    }

    @GetMapping("/{fleetId}/{contractId}")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<DriverContract> getFleetContract(@PathVariable Long fleetId, @PathVariable Long contractId, @AuthenticationPrincipal UserDetails userDetails) {
        // Check if the user has the FLEET_fleetId role
        if (userDetails.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("FLEET_" + fleetId))) {
            return contractService.findById(contractId)
                    .map(ResponseEntity::ok)
                    .orElse(ResponseEntity.notFound().build());
        } else {
            throw new AccessDeniedException("User does not have the required role");
        }
    }

    @GetMapping("/general/{contractId}")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN') and hasAuthority('GET_GENERAL_CONTRACT')")
    public ResponseEntity<DriverContract> getFleetContract(@PathVariable Long contractId, @AuthenticationPrincipal UserDetails userDetails) {
        return contractService.findById(contractId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping("/create")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Object> createContract(@RequestBody ContractCreationRequest request, @AuthenticationPrincipal UserDetails userDetails) {
        // Check if the user has the FLEET_fleetId role
        if ((request.fleetId() != null && userDetails.getAuthorities().stream().anyMatch(a ->
                        a.getAuthority().equals("FLEET_" + request.fleetId())
        )) || userDetails.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("CREATE_GENERAL_CONTRACT"))) {
            contractService.createContract(request);
            return ResponseEntity.ok().build();
        } else {
            System.out.println("User does not have the required role");
            throw new AccessDeniedException("User does not have the required role");
        }
    }

    @PutMapping("/update/{contractId}")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<DriverContract> updateContract(@PathVariable Long contractId, @RequestBody DriverContract contract, @AuthenticationPrincipal UserDetails userDetails) {
        // Check if the user has the FLEET_fleetId role
        if (/*(contract.getFleet() != null && userDetails.getAuthorities().stream().anyMatch(a ->
                a.getAuthority().equals("FLEET_" + contract.getFleet().getId())
        )) || */userDetails.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("UPDATE_GENERAL_CONTRACT"))) {
            return ResponseEntity.ok(contractService.updateContract(contractId, contract));
        } else {
            throw new AccessDeniedException("User does not have the required role");
        }
    }

    @DeleteMapping("/{fleetId}/{contractId}")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> deleteContract(@PathVariable Long fleetId, @PathVariable Long contractId, @AuthenticationPrincipal UserDetails userDetails) {
        // Check if the user has the FLEET_fleetId role
        if (userDetails.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("FLEET_" + fleetId))) {
            contractService.deleteById(contractId);
            return ResponseEntity.ok().build();
        } else {
            throw new AccessDeniedException("User does not have the required role");
        }
    }

    @DeleteMapping("/general/{contractId}")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN') or hasAuthority('DELETE_GENERAL_CONTRACT')")
    public ResponseEntity<Object> deleteContract(@PathVariable Long contractId) {
        return contractService.findById(contractId)
                .map(contract -> {
                    contractService.deleteById(contractId);
                    return ResponseEntity.ok().build();
                })
                .orElse(ResponseEntity.notFound().build());
    }

}
