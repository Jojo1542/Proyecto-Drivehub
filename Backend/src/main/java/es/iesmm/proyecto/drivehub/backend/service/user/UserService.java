package es.iesmm.proyecto.drivehub.backend.service.user;

import es.iesmm.proyecto.drivehub.backend.model.http.request.user.DriverModificationRequest;
import es.iesmm.proyecto.drivehub.backend.model.http.request.user.UserModificationRequest;
import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import es.iesmm.proyecto.drivehub.backend.model.user.balance.type.BalanceChangeType;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.license.DriverLicense;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import java.util.List;
import java.util.Optional;

public interface UserService extends UserDetailsService {

    default UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        return findByEmail(username).orElseThrow(() -> new UsernameNotFoundException("User not found"));
    }

    UserModel save(UserModel userModel);

    Optional<UserModel> findByEmail(String email);

    Optional<UserModel> findByDNI(String DNI);

    Optional<UserModel> findById(Long id);

    void delete(UserModel userModel);

    void deleteById(Long id);

    boolean existsByEmail(String email);

    boolean existsById(Long id);

    List<UserModel> findAll();

    Page<UserModel> findAllPaged(Pageable pageable);

    void updateUserByRequest(UserModel user, UserModificationRequest request);

    void updateUserBalance(Long id, double amount, BalanceChangeType type);

    void updateUserByAdmin(Long ip, UserModel request);

    long count();

    void createDefaultUser(String defaultAdminEmail, String password);

    List<UserModel> findDriversByFleet(Long fleetId);

    List<DriverLicense> findDriverLicensesByDriver(Long driverId);

    void addDriverLicenseToDriver(Long driverId, DriverLicense license);

    void removeDriverLicenseFromDriver(Long driverId, String licenseId);

    void updateDriverByRequest(UserModel user, DriverModificationRequest request);

    void updateAdminPermissions(Long id, List<String> permissions);
}