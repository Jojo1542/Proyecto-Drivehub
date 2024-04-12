package es.iesmm.proyecto.drivehub.backend.model.user;

import es.iesmm.proyecto.drivehub.backend.util.converter.RoleListConverter;
import es.iesmm.proyecto.drivehub.backend.model.user.roles.UserRoles;
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
	
	private String firstName;
	private String lastName;
	private String email;
	private String password;

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

	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		return roles.stream().map(UserRoles::getGrantedAuthority).toList();
	}

	@Override
	public String getUsername() {
		return email;
	}

	@Override
	public boolean isAccountNonExpired() {
		return true;
	}

	@Override
	public boolean isAccountNonLocked() {
		return true;
	}

	@Override
	public boolean isCredentialsNonExpired() {
		return true;
	}

	@Override
	public boolean isEnabled() {
		return true;
	}
}
