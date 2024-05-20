package es.iesmm.proyecto.drivehub.backend.controller.status;

import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/status")
@AllArgsConstructor
public class StatusController {

    @RequestMapping("/ping")
    public String ping() {
        return "pong";
    }

}
