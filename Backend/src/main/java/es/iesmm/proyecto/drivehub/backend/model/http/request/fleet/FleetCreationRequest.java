package es.iesmm.proyecto.drivehub.backend.model.http.request.fleet;

import es.iesmm.proyecto.drivehub.backend.model.fleet.Fleet;
import es.iesmm.proyecto.drivehub.backend.model.fleet.vehicle.VehicleType;

import java.util.LinkedList;

public record FleetCreationRequest(String name, String CIF, VehicleType vehicleType) {

    public Fleet toFleet() {
        return Fleet.builder()
                .name(name)
                .CIF(CIF)
                .vehicleType(vehicleType)
                .drivers(new LinkedList<>())
                .build();
    }

}
