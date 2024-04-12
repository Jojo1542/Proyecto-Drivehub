package es.iesmm.proyecto.drivehub.backend.controller;

import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import java.security.Principal;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/user")
public class UserUserController {

    @GetMapping("/me")
    @ResponseBody
    public String me(@AuthenticationPrincipal UserDetails userDetails) {
        UserModel userModel = (UserModel) userDetails;
        return "Hello " + userModel.getFirstName() + " " + userModel.getLastName() + "! " +
                "Your email is " + userModel.getEmail() + " and your ID is " + userModel.getId() +
                ". Your roles are " + userModel.getRoles().stream().map(Enum::name).toList() + ".";
    }

}
