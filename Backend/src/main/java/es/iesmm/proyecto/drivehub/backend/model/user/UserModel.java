package es.iesmm.proyecto.drivehub.backend.model.user;

import com.fasterxml.jackson.annotation.*;
import es.iesmm.proyecto.drivehub.backend.model.rent.history.UserRent;
import es.iesmm.proyecto.drivehub.backend.model.user.admin.AdminModelData;
import es.iesmm.proyecto.drivehub.backend.model.user.balance.BalanceChange;
import es.iesmm.proyecto.drivehub.backend.model.user.balance.type.BalanceChangeType;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.DriverModelData;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.chauffeur.ChauffeurDriverModelData;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.fleet.FleetDriverModelData;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.license.DriverLicense;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.license.type.DriverLicenseType;
import es.iesmm.proyecto.drivehub.backend.model.user.roles.UserRoles;
import es.iesmm.proyecto.drivehub.backend.util.converter.RoleListConverter;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Pattern;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;
import org.springframework.data.jpa.domain.AbstractPersistable;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.*;
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
	@Column(name = "roles", nullable = false, length = 1500)
	private List<UserRoles> roles;

	@OneToMany(mappedBy = "user", fetch = FetchType.EAGER, orphanRemoval = true)
	@JsonIgnore
	private List<UserRent> userRent;

	/*
	COLUMNAS OPCIONALES
	 */
	private Date birthDate;

	@Column(name = "saldo")
	@ColumnDefault("0")
	private double balance;
	private String phone;

	// Validar DNI con un patrón
	@Pattern(regexp = "^[0-9]{8}[A-Z]$")
	private String DNI;

	/*
	 * RELACIONES CON LA INFORMACIÓN DE LOS USUARIOS EN CASO DE TENERLA
	 */
	@JsonInclude(JsonInclude.Include.NON_NULL)
	@OneToOne(cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.EAGER)
	@JoinColumn(name = "admin_data_id", referencedColumnName = "id")
	private AdminModelData adminData;

	@JsonInclude(JsonInclude.Include.NON_NULL)
	@OneToOne(cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.EAGER)
	@JoinColumn(name = "driver_data_id", referencedColumnName = "id")
	private DriverModelData driverData;

	@OneToMany(mappedBy = "user", fetch = FetchType.EAGER, cascade = CascadeType.ALL, orphanRemoval = true)
	@JsonIgnoreProperties("user")
	private Set<DriverLicense> driverLicenses = new HashSet<>();

	@OneToMany(cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.EAGER)
	@JoinColumn(name = "user_id")
	private List<BalanceChange> balanceHistory = new LinkedList<>();
	
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

	public boolean hasRentActive() {
		return userRent.stream().anyMatch(UserRent::isActive);
	}

	public boolean hasRegisteredLicenseType(DriverLicenseType type) {
		return driverLicenses.stream().anyMatch(dl -> dl.getType().equals(type));
	}

	public boolean canAfford(double amount) {
		return balance >= amount;
	}

	public void deposit(double amount) {
		balance += amount;

		balanceHistory.add(BalanceChange.builder()
				.user(this)
				.amount(amount)
				.type(BalanceChangeType.DEPOSIT)
				.registerDate(new Date())
				.build());
	}

	public void withdraw(double amount) {
		balance -= amount;

		balanceHistory.add(BalanceChange.builder()
				.user(this)
				.amount(amount)
				.type(BalanceChangeType.WITHDRAW)
				.registerDate(new Date())
				.build());
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
				adminData.setUserModel(this);
			}
		} else {
			adminData = null;
		}

		if (roles.contains(UserRoles.DRIVER_FLEET)) {
			if (driverData == null || !(driverData instanceof FleetDriverModelData)) {
				driverData = new FleetDriverModelData();
				driverData.setUserModel(this);
			}
		} else if (roles.contains(UserRoles.DRIVER_CHAUFFEUR)) {
			if (driverData == null || !(driverData instanceof ChauffeurDriverModelData)) {
				driverData = new ChauffeurDriverModelData();
				driverData.setUserModel(this);
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
