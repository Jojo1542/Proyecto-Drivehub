package es.iesmm.proyecto.drivehub.backend.controller.contract;

import es.iesmm.proyecto.drivehub.backend.model.http.request.contract.ContractCreationRequest;
import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.contract.DriverContract;
import es.iesmm.proyecto.drivehub.backend.service.contract.ContractService;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ProblemDetail;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import static es.iesmm.proyecto.drivehub.backend.util.permission.PermissionUtils.*;

@RestController
@RequestMapping("/contract")
@AllArgsConstructor
public class ContractController {

    private final ContractService contractService;

    @PostMapping("/create")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<DriverContract> createContract(@RequestBody ContractCreationRequest request, @AuthenticationPrincipal UserDetails userDetails) {
        UserModel user = (UserModel) userDetails;
        Long fleetId = request.fleetId();

        if (hasFleetPermission(user, fleetId) || hasAdminPermission(user, "CREATE_GENERAL_CONTRACT")) {
            try {
                return ResponseEntity.ok(contractService.createContract(request));
            } catch (IllegalArgumentException e) {
                return ResponseEntity.of(ProblemDetail.forStatusAndDetail(HttpStatus.NOT_FOUND, e.getMessage())).build();
            }
        } else {
            throw new AccessDeniedException("User does not have the required role");
        }
    }

    /*
    FUNCIONES DEL PROPIO CONDUCTOR
     */
    @GetMapping("/own/actual")
    @ResponseBody
    @PreAuthorize("hasRole('DRIVER_FLEET') or hasRole('DRIVER_CHAUFFEUR')")
    public ResponseEntity<DriverContract> getOwnContract(@AuthenticationPrincipal UserDetails userDetails) {
        UserModel user = (UserModel) userDetails;
        return contractService.getActualContract(user)
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("/own/all")
    @ResponseBody
    @PreAuthorize("hasRole('DRIVER_FLEET') or hasRole('DRIVER_CHAUFFEUR')")
    public List<DriverContract> getOwnContracts(@AuthenticationPrincipal UserDetails userDetails) {
        UserModel user = (UserModel) userDetails;
        return contractService.findByDriver(user);
    }

    /*
    FUNCIONES ADMINISTRATIVAS (SUPER ADMIN)
     */
    @GetMapping("/all")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN') and hasAuthority('SUPER_ADMIN')")
    public ResponseEntity<List<DriverContract>> getAllContracts() {
        return ResponseEntity.ok(contractService.findAll());
    }

    /*
    FUNCIONES DE CONTRATOS GENERALES (NO ASOCIADOS A UNA FLOTA)
     */
    @GetMapping("/general/all")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN') and hasAuthority('GET_GENERAL_CONTRACT')")
    public ResponseEntity<List<DriverContract>> getAllGeneralContracts() {
        return ResponseEntity.ok(contractService.findAllGeneral());
    }

    @GetMapping("/general/{contractId}")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN') and hasAuthority('GET_GENERAL_CONTRACT')")
    public ResponseEntity<DriverContract> getContract(@PathVariable Long contractId) {
        return contractService.findGeneralById(contractId)
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @DeleteMapping("/general/{contractId}")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN') and hasAuthority('DELETE_GENERAL_CONTRACT')")
    public ResponseEntity<Object> finalizeGeneralContract(@PathVariable Long contractId) {
        return contractService.findGeneralById(contractId)
                .map(contract -> {
                    try {
                        contractService.finalizeContract(contractId);
                        return ResponseEntity.ok().build();
                    } catch (IllegalStateException e) {
                        return ResponseEntity.of(ProblemDetail.forStatusAndDetail(HttpStatus.CONFLICT, e.getMessage())).build();
                    }
                })
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    /*
    FUNCIONES DE CONTRATOS DE FLOTA (ASOCIADOS A UNA FLOTA)
    */
    @GetMapping("/fleet/{fleetId}/all")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<DriverContract>> getAllFleetContracts(@PathVariable Long fleetId, @AuthenticationPrincipal UserDetails userDetails) {
        UserModel user = (UserModel) userDetails;

        if (hasFleetPermission(user, fleetId) || hasAdminPermission(user, "SUPER_ADMIN")) {
            return ResponseEntity.ok(contractService.findAllByFleet(fleetId));
        } else {
            throw new AccessDeniedException("User does not have the required role");
        }
    }

    @GetMapping("/fleet/{fleetId}/{contractId}")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<DriverContract> getFleetContract(@PathVariable Long fleetId, @PathVariable Long contractId, @AuthenticationPrincipal UserDetails userDetails) {
        UserModel user = (UserModel) userDetails;

        if (hasFleetPermission(user, fleetId) || hasAdminPermission(user, "SUPER_ADMIN")) {
            return contractService.findContractByIdFleet(contractId, fleetId)
                    .map(ResponseEntity::ok)
                    .orElseGet(() -> ResponseEntity.notFound().build());
        } else {
            throw new AccessDeniedException("User does not have the required role");
        }
    }

    @DeleteMapping("/fleet/{fleetId}/{contractId}")
    @ResponseBody
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Object> finalizeFleetContract(@PathVariable Long fleetId, @PathVariable Long contractId, @AuthenticationPrincipal UserDetails userDetails) {
        UserModel user = (UserModel) userDetails;

        if (hasFleetPermission(user, fleetId) || hasAdminPermission(user, "SUPER_ADMIN")) {
            return contractService.findContractByIdFleet(contractId, fleetId)
                    .map(contract -> {
                        try {
                            contractService.finalizeContract(contractId);
                            return ResponseEntity.ok().build();
                        } catch (IllegalStateException e) {
                            return ResponseEntity.of(ProblemDetail.forStatusAndDetail(HttpStatus.CONFLICT, e.getMessage())).build();
                        }
                    })
                    .orElseGet(() -> ResponseEntity.notFound().build());
        } else {
            throw new AccessDeniedException("User does not have the required role");
        }
    }

}
