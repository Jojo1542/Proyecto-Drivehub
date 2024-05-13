package es.iesmm.proyecto.drivehub.backend.model.user;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import es.iesmm.proyecto.drivehub.backend.model.rent.history.UserRent;
import es.iesmm.proyecto.drivehub.backend.model.user.admin.AdminModelData;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.DriverModelData;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.chauffeur.ChauffeurDriverModelData;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.fleet.FleetDriverModelData;
import es.iesmm.proyecto.drivehub.backend.model.user.roles.UserRoles;
import es.iesmm.proyecto.drivehub.backend.util.converter.RoleListConverter;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;
import org.springframework.data.jpa.domain.AbstractPersistable;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@Table(
		name = "USUARIOS",
		uniqueConstraints = {
				@UniqueConstraint(name = "UQ_USER_EMAIL", columnNames="email"),
				@UniqueConstraint(name = "UQ_USER_DNI", columnNames="DNI")
		}
)
@Entity
@Getter
@Setter
@AllArgsConstructor
public class UserModel extends AbstractPersistable<Long> implements UserDetails {

	/*
	 * COLUMNAS REQUERIDAS
	 */
	@NotEmpty
	private String email;

	@JsonIgnore // Por razones obvias no vamos a pasar las contraseñas
	@NotEmpty
	private String password;

	@NotEmpty
	private String firstName;

	@NotEmpty
	private String lastName;

	@Convert(converter = RoleListConverter.class)
	@Column(name = "roles", nullable = false)
	private List<UserRoles> roles;

	@OneToMany(mappedBy = "user")
	@JsonProperty("rents")
	private List<UserRent> userRent;

	/*
	COLUMNAS OPCIONALES
	 */
	private Date birthDate;
	private double saldo;
	private String phone;

	// Validar DNI con un patrón
	@Pattern(regexp = "^[0-9]{8}[A-Z]$")
	private String DNI;

	/*
	 * RELACIONES CON LA INFORMACIÓN DE LOS USUARIOS EN CASO DE TENERLA
	 */
	@JsonInclude(JsonInclude.Include.NON_NULL)
	@OneToOne(cascade = CascadeType.ALL, orphanRemoval = true)
	@PrimaryKeyJoinColumn(name = "id")
	private AdminModelData adminData;

	@JsonInclude(JsonInclude.Include.NON_NULL)
	@OneToOne(cascade = CascadeType.ALL, orphanRemoval = true)
	@PrimaryKeyJoinColumn(name = "id")
	private DriverModelData driverData;
	
	public UserModel(String email, String password, String firstName, String lastName) {
		this.email = email;
		this.password = password;
		this.firstName = firstName;
		this.lastName = lastName;
		this.phone = "";
		this.roles = List.of(UserRoles.USER);
	}

	public UserModel() {}

	public void setEmail(String email) {
		this.email = email.toLowerCase(); // Se guarda el email en minúsculas para evitar problemas de mayúsculas y minúsculas
	}

	/*
	 * Metodo de control de los roles de los usuarios y sus datos asociados.
	 */
	@PostLoad
	@PrePersist
	@PreUpdate
	public void checkRoles() {
		if (roles.contains(UserRoles.ADMIN)) {
			if (adminData == null) {
				adminData = new AdminModelData();
			}
		} else {
			adminData = null;
		}

		if (roles.contains(UserRoles.DRIVER_FLEET)) {
			if (driverData == null || !(driverData instanceof FleetDriverModelData)) {
				driverData = new FleetDriverModelData();
			}
		} else if (roles.contains(UserRoles.DRIVER_CHAUFFEUR)) {
			if (driverData == null || !(driverData instanceof ChauffeurDriverModelData)) {
				driverData = new ChauffeurDriverModelData();
			}
		} else {
			driverData = null;
		}
	}

	/*
	 * Métodos necesarios de la clase UserDetails, se utilizan para la autenticación de los usuarios.
	 *
	 * @see org.springframework.security.core.userdetails.UserDetails
	 * @see org.springframework.security.core.GrantedAuthority
	 * @see es.iesmm.proyecto.drivehub.backend.model.user.roles.UserRoles
	 * @see es.iesmm.proyecto.drivehub.backend.util.converter.RoleListConverter
	 *
	 * IMPORTANTE: Estos métodos deben tener la anotación @JsonIgnore para que no se serialicen en las respuestas JSON hacia el cliente.
	 */
	@Override
	@JsonIgnore
	public Collection<? extends GrantedAuthority> getAuthorities() {
		Collection<GrantedAuthority> grantedAuthorities = roles.stream().map(UserRoles::getGrantedAuthority).collect(Collectors.toList());

		// Si el usuario es administrador, añadimos los permisos de administrador a sus permisos para poder controlarlos
		if (adminData != null) {
			grantedAuthorities.addAll(adminData.getAuthorities());
		}

		System.out.println(grantedAuthorities.stream().map(GrantedAuthority::getAuthority).collect(Collectors.joining(", ")));

		return grantedAuthorities;
	}

	@Override
	@JsonIgnore
	public String getUsername() {
		return email;
	}

	@Override
	@JsonIgnore
	public boolean isAccountNonExpired() {
		return true;
	}

	@Override
	@JsonIgnore
	public boolean isAccountNonLocked() {
		return true;
	}

	@Override
	@JsonIgnore
	public boolean isCredentialsNonExpired() {
		return true;
	}

	@Override
	@JsonIgnore
	public boolean isEnabled() {
		return true;
	}

	@Override
	@JsonIgnore
	public boolean isNew() {
		return super.isNew();
	}
}
