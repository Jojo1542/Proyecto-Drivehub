package es.iesmm.proyecto.drivehub.backend.model.user.admin;

import com.fasterxml.jackson.annotation.JsonIgnore;
import es.iesmm.proyecto.drivehub.backend.model.fleet.Fleet;
import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import es.iesmm.proyecto.drivehub.backend.model.user.admin.permisison.AdminPermission;
import es.iesmm.proyecto.drivehub.backend.util.converter.AdminPermissionListConverter;
import es.iesmm.proyecto.drivehub.backend.util.converter.LongListConverter;
import es.iesmm.proyecto.drivehub.backend.util.converter.RoleListConverter;
import es.iesmm.proyecto.drivehub.backend.util.converter.StringListConverter;
import jakarta.annotation.PostConstruct;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotEmpty;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;
import org.springframework.security.core.GrantedAuthority;

import java.util.Arrays;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;
import java.util.stream.Stream;

@Table(name = "ADMINISTRADOR")
@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class AdminModelData {

    private final static String FLEET_PREFIX = "FLEET_";

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    @JsonIgnore
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_usuario")
    @JsonIgnore
    private UserModel userModel;

    @Column(name = "flotas_con_acceso")
    @Convert(converter = LongListConverter.class)
    @ColumnDefault("''")
    private List<Long> fleetPermissions = new LinkedList<>();

    @Column(name = "general_permissions")
    @Convert(converter = AdminPermissionListConverter.class)
    @ColumnDefault("''")
    private List<AdminPermission> generalPermissions = new LinkedList<>();

    @NotEmpty
    @Column(name = "horario")
    @ColumnDefault("'08:00-20:00'")
    private String avaiableTime = "08:00-20:00";

    @PrePersist
    public void defaultValues() {
        if (this.avaiableTime == null) {
            this.avaiableTime = "08:00-20:00";
        }

        if (this.fleetPermissions == null) {
            this.fleetPermissions = new LinkedList<>();
        }

        if (this.generalPermissions == null) {
            this.generalPermissions = new LinkedList<>();
        }
    }

    public boolean hasFleetPermission(Long fleetId) {
        return this.fleetPermissions.contains(fleetId);
    }

    public void addFleetPermission(Fleet fleet) {
        this.fleetPermissions.add(fleet.getId());
    }

    public void removeFleetPermission(Fleet fleet) {
        this.fleetPermissions.remove(fleet.getId());
    }

    public boolean hasGeneralPermission(AdminPermission permission) {
        return this.generalPermissions.contains(permission);
    }

    public void addGeneralPermission(AdminPermission permission) {
        this.generalPermissions.add(permission);
    }

    public void removeGeneralPermission(AdminPermission permission) {
        this.generalPermissions.remove(permission);
    }

    @JsonIgnore
    public List<GrantedAuthority> getAuthorities() {
        return Stream.concat(
                this.generalPermissions.stream().map(AdminPermission::getGrantedAuthority),
                this.fleetPermissions.stream().map(String::valueOf).map(this::getGrantedAuthorityForFleetAccess)
        ).toList();
    }

    private GrantedAuthority getGrantedAuthorityForFleetAccess(String fleetId) {
        return () -> FLEET_PREFIX + fleetId;
    }

    public void giveAllPermissions() {
        this.generalPermissions = Arrays.asList(AdminPermission.values());
    }
}
