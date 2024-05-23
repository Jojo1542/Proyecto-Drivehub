package es.iesmm.proyecto.drivehub.backend.controller.trip;

import es.iesmm.proyecto.drivehub.backend.model.http.request.trip.TripDraftRequest;
import es.iesmm.proyecto.drivehub.backend.model.trip.TripModel;
import es.iesmm.proyecto.drivehub.backend.model.trip.draft.TripDraftModel;
import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import es.iesmm.proyecto.drivehub.backend.service.trip.TripService;
import es.iesmm.proyecto.drivehub.backend.service.user.UserService;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ProblemDetail;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/trip")
@AllArgsConstructor
public class TripController {

    private final TripService tripService;
    private final UserService userService;

    @PostMapping("/draft")
    @ResponseBody
    public ResponseEntity<TripDraftModel> createDraft(@AuthenticationPrincipal UserDetails userDetails, @RequestBody TripDraftRequest request) {
        UserModel user = (UserModel) userDetails;
        try {
            return ResponseEntity.ok(tripService.createDraft(user, request.origin(), request.destination()));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.of(ProblemDetail.forStatusAndDetail(HttpStatus.BAD_REQUEST, e.getMessage())).build();
        }
    }

    @GetMapping("/draft/{id}")
    @ResponseBody
    public ResponseEntity<TripDraftModel> getDraft(@PathVariable String id) {
        return tripService.findDraft(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping("/start/{draftId}")
    @ResponseBody
    public ResponseEntity<TripModel> startTrip(@AuthenticationPrincipal UserDetails userDetails, @PathVariable String draftId, @RequestParam(required = false, defaultValue = "false") boolean sendPackage) {
        UserModel user = (UserModel) userDetails;
        try {
            Optional<TripDraftModel> tripDraftModel = tripService.findDraft(draftId);

            return tripDraftModel
                    .map(draftModel -> ResponseEntity.ok(tripService.createTrip(user, draftModel, sendPackage)))
                    .orElseGet(() -> ResponseEntity.notFound().build());
        } catch (IllegalArgumentException e) {
            return ResponseEntity.of(ProblemDetail.forStatusAndDetail(HttpStatus.BAD_REQUEST, e.getMessage())).build();
        } catch (IllegalStateException e) {
            return ResponseEntity.of(ProblemDetail.forStatusAndDetail(HttpStatus.CONFLICT, e.getMessage())).build();
        }
    }

}
