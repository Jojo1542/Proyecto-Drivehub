package es.iesmm.proyecto.drivehub.backend.model.http.request.user;

import es.iesmm.proyecto.drivehub.backend.model.user.UserModel;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.DriverModelData;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.chauffeur.ChauffeurDriverModelData;
import es.iesmm.proyecto.drivehub.backend.model.user.driver.fleet.FleetDriverModelData;

public record DriverModificationRequest(
        String avaiableTime,
        double preferedDistance,
        String vehicleModel,
        String vehiclePlate,
        String vehicleColor,
        double maxTonnage
) {

    public void applyToUser(UserModel user) {
        DriverModelData driverData = user.getDriverData();

        if (avaiableTime != null) {
            driverData.setAvaiableTime(avaiableTime);
        }

        if (driverData instanceof ChauffeurDriverModelData chauffeurDriverData) {
            if (preferedDistance != 0) {
                chauffeurDriverData.setPreferedDistance(preferedDistance);
            }

            if (vehicleModel != null) {
                chauffeurDriverData.setVehicleModel(vehicleModel);
            }

            if (vehiclePlate != null) {
                chauffeurDriverData.setVehiclePlate(vehiclePlate);
            }

            if (vehicleColor != null) {
                chauffeurDriverData.setVehicleColor(vehicleColor);
            }

            user.setDriverData(chauffeurDriverData);
        } else if (driverData instanceof FleetDriverModelData fleetDriverData) {
            if (maxTonnage != 0) {
                fleetDriverData.setMaxTonnage(maxTonnage);
            }

            user.setDriverData(fleetDriverData);
        }
    }
}
