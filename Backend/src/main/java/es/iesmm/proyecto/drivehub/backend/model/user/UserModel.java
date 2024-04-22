package es.iesmm.proyecto.drivehub.backend.model.user;

import com.fasterxml.jackson.annotation.JsonIgnore;
import es.iesmm.proyecto.drivehub.backend.model.user.roles.UserRoles;
import es.iesmm.proyecto.drivehub.backend.util.converter.RoleListConverter;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.jpa.domain.AbstractPersistable;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.List;

@Table(
		name = "USERS",
		uniqueConstraints = @UniqueConstraint(columnNames={"email"})
)
@Entity
@Getter
@Setter
public class UserModel extends AbstractPersistable<Long> implements UserDetails {

	private String email;

	@JsonIgnore // Por razones obvias no vamos a pasar las contraseñas
	private String password;

	private String firstName;

	private String lastName;

	@Convert(converter = RoleListConverter.class)
	@Column(name = "roles", nullable = false)
	private List<UserRoles> roles;
	
	public UserModel(String email, String password, String firstName, String lastName) {
		this.email = email;
		this.password = password;
		this.firstName = firstName;
		this.lastName = lastName;
		this.roles = List.of(UserRoles.USER);
	}
	
	public UserModel() {}

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
		return roles.stream().map(UserRoles::getGrantedAuthority).toList();
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
