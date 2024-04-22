package es.iesmm.proyecto.drivehub.backend.controller.user;

import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/user")
public class UserController {

    @GetMapping("/me")
    @ResponseBody
    public UserModel me(@AuthenticationPrincipal UserDetails userDetails) {
        return (UserModel) userDetails;
    }
}
