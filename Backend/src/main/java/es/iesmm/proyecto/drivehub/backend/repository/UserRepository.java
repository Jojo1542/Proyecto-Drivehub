package es.iesmm.proyecto.drivehub.backend.repository;

import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<UserModel, Long> {
	
	@Query("SELECT u FROM UserModel u WHERE email = LOWER(:email)")
	UserModel findByEmail(String email);

	@Query("SELECT u FROM UserModel u WHERE DNI = :dni")
	UserModel findByDNI(String dni);
}
