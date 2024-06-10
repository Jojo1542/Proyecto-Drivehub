//
//  DriverViewModel.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 19/5/24.
//

import Foundation
import CoreLocation

class DriverViewModel: ObservableObject {
    
    private var appModel: AppViewModel;
    private var locationService: LocationService;
    
    init(appModel: AppViewModel) {
        self.appModel = appModel;
        self.locationService = LocationService(background: true);
    }
    
    var user: UserModel {
        return self.appModel.getUser();
    }
    
    var sessionToken: String {
        return self.appModel.getSessionToken()
    }
    
    var driverData: UserModel.DriverData {
        return self.appModel.getUser().driverData!;
    }
    
    var lastLocation: CLLocation {
        return self.locationService.getLastLocation()!;
    }
    
    func startUpdatingLocation() {
        self.locationService.startUpdatingLocation(callback: { location in
            self.appModel.updateLocationToServer(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude);
        })
    }
    
    func stopUpdatingLocation() {
        self.locationService.stopUpdatingLocation();
    }
    
    func isUpdatingLocation() -> Bool {
        return self.locationService.isUpdatingLocation();
    }
    
    func updateDriver(data: UserUpdateDriverRequest.RequestBody, completion: @escaping (Callback<Void, Int>) -> Void) {
        UserUpdateDriverRequest.updateDriver(sessionToken: self.sessionToken, body: data, completion: { response in
            switch response {
                case .success(_):
                    completion(.success())
                case .failure(let error):
                    completion(.failure(data: error))
            }
        });
    }
    
}
