//
//  ChauffeurDriverViewModel.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 25/5/24.
//

import Foundation
import CoreLocation
import SwiftUI

class ChauffeurDriverViewModel: ObservableObject {
    
    private var driverModel: DriverViewModel;
    @Published var activeTrip: TripModel?;
    @Published var offeredTrip: TripModel?;
    
    private var dutyListener: SseService<TripModel>;
    
    init(driverModel: DriverViewModel) {
        self.driverModel = driverModel;
        
        self.dutyListener = NetworkListeners.getDutyListener(sessionToken: self.driverModel.sessionToken);
    }
    
    var lastLocation: CLLocation {
        return self.driverModel.lastLocation;
    }
    
    func startUpdatingLocation() {
        self.driverModel.startUpdatingLocation();
        
        // Iniciar el servicio
        self.dutyListener.onMessage { trip in
            if trip.status == .PENDING {
                withAnimation(.spring) {
                    self.offeredTrip = trip;
                }
            }
        }
        
        // Conectar al servidor
        self.dutyListener.connect()
    }
    
    func stopUpdatingLocation() {
        self.driverModel.stopUpdatingLocation();
        
        // Detener el servicio
        self.dutyListener.disconnect()
    }
    
    func isUpdatingLocation() -> Bool {
        return self.driverModel.isUpdatingLocation();
    }
    
    func updateVehicleData(vehiclePlate: String, vehicleModel: String, vehicleColor: String, completion: @escaping (Callback<Void, Int>) -> Void) {
        driverModel.updateDriver(data: UserUpdateDriverRequest.RequestBody(
            vehicleModel: vehicleModel,
            vehiclePlate: vehiclePlate,
            vehicleColor: vehicleColor
        ), completion: completion)
    }
    
    func updatePersonalData(avaiableTime: String, preferedDistance: Double, completion: @escaping (Callback<Void, Int>) -> Void) {
        driverModel.updateDriver(data: UserUpdateDriverRequest.RequestBody(
            avaiableTime: avaiableTime,
            preferedDistance: preferedDistance
        ), completion: completion)
    }
    
    func refreshActiveTrip() {
        GetDriverActiveTripRequest.getActiveTrip(sessionToken: driverModel.sessionToken) { request in
            switch request {
            case .success(let data):
                self.activeTrip = data;
            case .failure(let error):
                if error == 404 {
                    self.activeTrip = nil;
                } else {
                    print("Error getting active trip: \(error!)");
                }
                
            }
        }
    }
    
    func acceptTrip(tripId: Int, completion: @escaping (Callback<Void, Int>) -> Void) {
        AcceptTripRequest.acceptTrip(sessionToken: driverModel.sessionToken, tripId: tripId) { result in
            switch result {
                case .success:
                    completion(.success())
                    self.activeTrip = self.offeredTrip;
                    self.offeredTrip = nil;
                
                    // Para no actualizar desde la api, se cambian directmaente aquí los parametros.
                    self.activeTrip?.status = .ACCEPTED;
                    self.activeTrip?.driver = TripModel.DriverInfo(
                        id: self.driverModel.user.id,
                        firstName: self.driverModel.user.firstName,
                        lastName: self.driverModel.user.lastName,
                        dni: self.driverModel.user.dni!,
                        birthDate: self.driverModel.user.birthDate!
                    )
                    print("accepted")
                case .failure(let error):
                    completion(.failure(data: error))
                    print("error accepting trip")
            }
        }
    }
    
    func finalizeTrip(tripId: Int, cancelled: Bool = false, completion: @escaping (Callback<Void, Int>) -> Void) {
        FinishTripRequest.finishTrip(sessionToken: driverModel.sessionToken, cancelledByDriver: cancelled) { result in
            switch result {
                case .success:
                    completion(.success())
                    self.activeTrip = nil;
                    self.offeredTrip = nil;
                
                    self.refreshActiveTrip();
                case .failure(let error):
                    completion(.failure(data: error))
            }
        }
    }
    
}
