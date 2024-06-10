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
    
    var lastLatitude: Double?
    var lastLongitude: Double?
    
    // Create a constructor with args
    public init(background: Bool) {
        self.locationManager = CLLocationManager()
        super.init()
        self.locationManager.delegate = self
        
        // Dependiendo de si va a estar solicitando de fondo o no, se piden permisos
        if (background) {
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.allowsBackgroundLocationUpdates = true
            self.locationManager.pausesLocationUpdatesAutomatically = false
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        } else {
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.allowsBackgroundLocationUpdates = false
            self.locationManager.pausesLocationUpdatesAutomatically = true
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
    }
    
    func startUpdatingLocation(callback: @escaping (CLLocation) -> Void = { _ in }) {
        self.locationManager.startUpdatingLocation()
        self.callback = callback
        self.updatingLocation = true
    }
    
    func stopUpdatingLocation() {
        // Se ejecuta de forma asincrona para que no se bloquee el hilo principal
        DispatchQueue.main.async {
            self.locationManager.stopUpdatingLocation()
        }
        
        self.updatingLocation = false
    }
    
    func isUpdatingLocation() -> Bool {
        return self.updatingLocation
    }
    
    func getLastLocation() -> CLLocation? {
        return self.locationManager.location
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // No enviar duplicada la localización actual
        if self.lastLatitude != nil && self.lastLongitude != nil {
            if self.lastLatitude == location.coordinate.latitude && self.lastLongitude == location.coordinate.longitude {
                return
            }
        }
        
        self.lastLatitude = location.coordinate.latitude
        self.lastLongitude = location.coordinate.longitude
        
        // Devolver la localización al callback
        self.callback?(location)
    }
}
