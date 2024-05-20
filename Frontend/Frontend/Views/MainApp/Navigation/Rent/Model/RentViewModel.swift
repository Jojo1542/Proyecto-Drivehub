//
//  RentViewModel.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 17/5/24.
//

import Foundation

class RentViewModel: ObservableObject {
    
    private var appViewModel: AppViewModel;
    @Published var availableVehicles: [RentCarModel] = []
    @Published var actualRent: UserRentHistoryModel?
    
    init(appViewModel: AppViewModel) {
        self.appViewModel = appViewModel
    }
    
    func updateAvailableVehicles() {
        GetAvailableVehiclesRequest.getAvaiableVehicles(sessionToken: appViewModel.getSessionToken()) { result in
            switch result {
                case .success(let data):
                    self.availableVehicles = data!
                case .failure(let error):
                    print("Error getting available vehicles: \(error ?? -1)")
            }
        }
    }
    
    func updateActualRent() {
        GetActualRentRequest.getActualRent(sessionToken: appViewModel.getSessionToken()) { result in
            switch result {
                case .success(let data):
                    self.actualRent = data!
                case .failure(let error):
                    if error == 404 {
                        self.actualRent = nil
                    } else {
                        print("Error getting actual rent: \(error ?? -1)")
                    }
            }
        }
    }
    
    func rentVehicle(vehicleId: Int, completion: @escaping (Callback<Void, VehicleRentRequest.ErrorType>) -> Void) {
        VehicleRentRequest.rentVehicle(sessionToken: appViewModel.getSessionToken(), vehicleId: vehicleId) { result in
            switch result {
                case .success(_):
                    self.updateActualRent();
                    self.updateAvailableVehicles();
                    completion(.success())
                case .failure(let error):
                    completion(.failure(data: error))
            }
        }
    }
    
    func returnVehicle(vehicleId: Int, completion: @escaping (Callback<Void, VehicleReturnRequest.ErrorType>) -> Void) {
        VehicleReturnRequest.returnVehicle(sessionToken: appViewModel.getSessionToken(), vehicleId: vehicleId) { result in
            switch result {
                case .success(_):
                    self.updateActualRent();
                    self.updateAvailableVehicles();
                    completion(.success())
                case .failure(let error):
                    completion(.failure(data: error))
            }
        }
    }
    
}
