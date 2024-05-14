package es.iesmm.proyecto.drivehub.backend.model.http.request.contract;

import es.iesmm.proyecto.drivehub.backend.model.fleet.Fleet;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.DriverModelData;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.contract.DriverContract;

import java.util.Date;

public record ContractCreationRequest(
        Long driverId, Long fleetId, Date startDate, Date endDate, double salary
) {

    public DriverContract toDriverContract(DriverModelData driverModelData) {
        return DriverContract.builder()
                .driver(driverModelData)
                .startDate(startDate)
                .endDate(endDate)
                .salary(salary)
                .build();
    }
}
