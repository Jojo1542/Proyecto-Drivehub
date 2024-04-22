package es.iesmm.proyecto.drivehub.backend.service.user;

import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import java.util.Optional;

public interface UserService extends UserDetailsService {

    default UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        return findByEmail(username).orElseThrow(() -> new UsernameNotFoundException("User not found"));
    }

    UserModel save(UserModel userModel);

    Optional<UserModel> findByEmail(String email);

    Optional<UserModel> findById(Long id);

    void delete(UserModel userModel);

    void deleteById(Long id);

    boolean existsByEmail(String email);

    boolean existsById(Long id);
}