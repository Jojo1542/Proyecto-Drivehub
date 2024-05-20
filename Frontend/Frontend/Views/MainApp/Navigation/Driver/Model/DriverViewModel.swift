//
//  DriverViewModel.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 19/5/24.
//

import Foundation

class DriverViewModel: ObservableObject {
    
    private var appModel: AppViewModel;
    private var locationService: LocationService;
    
    init(appModel: AppViewModel) {
        self.appModel = appModel;
        self.locationService = LocationService();
    }
    
    var user: UserModel {
        return self.appModel.getUser();
    }
    
    var driverData: UserModel.DriverData {
        return self.appModel.getUser().driverData!;
    }
    
    func startUpdatingLocation() {
        self.locationService.startUpdatingLocation(callback: {location in
            print("Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        })
    }
    
    func stopUpdatingLocation() {
        self.locationService.stopUpdatingLocation();
    }
    
    func isUpdatingLocation() -> Bool {
        return self.locationService.isUpdatingLocation();
    }
    
}
