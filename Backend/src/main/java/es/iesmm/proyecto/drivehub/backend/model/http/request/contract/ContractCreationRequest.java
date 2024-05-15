package es.iesmm.proyecto.drivehub.backend.model.http.request.contract;

import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.DriverModelData;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.contract.DriverContract;

import java.util.Date;

public record ContractCreationRequest(
        Long driverId, Long fleetId, Date startDate, Date endDate, double salary
) {

    public DriverContract toDriverContract(UserModel userModel) {
        return DriverContract.builder()
                .driver(userModel)
                .startDate(startDate)
                .endDate(endDate)
                .salary(salary)
                .build();
    }
}
