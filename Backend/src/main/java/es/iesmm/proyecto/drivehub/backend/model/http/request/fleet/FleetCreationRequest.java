package es.iesmm.proyecto.drivehub.backend.model.http.request.fleet;

import com.google.common.base.Preconditions;
import es.iesmm.proyecto.drivehub.backend.model.fleet.Fleet;
import es.iesmm.proyecto.drivehub.backend.model.fleet.vehicle.VehicleType;

import java.util.LinkedList;

public record FleetCreationRequest(String name, String CIF, VehicleType vehicleType) {

    public Fleet toFleet() {
        Preconditions.checkNotNull(name, "Name cannot be null");
        Preconditions.checkNotNull(CIF, "CIF cannot be null");
        Preconditions.checkNotNull(vehicleType, "Vehicle type cannot be null");

        return Fleet.builder()
                .name(name)
                .CIF(CIF)
                .vehicleType(vehicleType)
                .drivers(new LinkedList<>())
                .build();
    }

}
