//
//  FleetDriverViewModel.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 19/5/24.
//

import Foundation

class FleetDriverViewModel: ObservableObject {
    
    private var driverModel: DriverViewModel;
    
    init(driverModel: DriverViewModel) {
        self.driverModel = driverModel;
    }
    
    var user: UserModel {
        return self.driverModel.user;
    }
    
    var driverData: UserModel.DriverData {
        return self.driverModel.driverData;
    }
    
    func startUpdatingLocation() {
        self.driverModel.startUpdatingLocation();
    }
    
    func stopUpdatingLocation() {
        self.driverModel.stopUpdatingLocation();
    }
    
    func isUpdatingLocation() -> Bool {
        return self.driverModel.isUpdatingLocation();
    }
    
}
