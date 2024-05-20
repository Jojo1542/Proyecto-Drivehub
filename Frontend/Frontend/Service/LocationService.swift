//
//  LocationService.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 19/5/24.
//

import Foundation
import CoreLocation

class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager;
    var callback: ((CLLocation) -> Void)?
    @Published var updatingLocation: Bool = false;
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.pausesLocationUpdatesAutomatically = false
    }
    
    func startUpdatingLocation(callback: @escaping (CLLocation) -> Void) {
        self.locationManager.startUpdatingLocation()
        self.callback = callback
        self.updatingLocation = true
    }
    
    func stopUpdatingLocation() {
        self.locationManager.stopUpdatingLocation()
        self.updatingLocation = false
    }
    
    func isUpdatingLocation() -> Bool {
        return self.updatingLocation
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // Devolver la localización al callback
        self.callback?(location)
    }
}
