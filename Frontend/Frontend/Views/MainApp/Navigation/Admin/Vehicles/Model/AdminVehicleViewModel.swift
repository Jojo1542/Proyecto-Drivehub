//
//  AdminVehicleListViewModel.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 21/5/24.
//

import Foundation

class AdminVehicleViewModel: ObservableObject {
    
    private var appViewModel: AppViewModel;
    @Published var vehicles: [RentCarModel] = []
    
    private var sessionToken: String {
        return appViewModel.getSessionToken()
    }
    
    public init(appModel: AppViewModel) {
        self.appViewModel = appModel;
    }
    
    func fetchVehicles() {
        GetAllVehiclesRequest.getVehicles(sessionToken: sessionToken) { result in
            switch result {
                case .success(let data):
                    self.vehicles = data!
                case .failure(let error):
                    print("Error fetching vehicles: \(error!)")
            }
        }
    }
    
    func fetchVehicleHistory(vehicleId: Int64, completion: @escaping (Callback<[UserRentHistoryModel], Int>) -> Void) {
        GetVehicleRentHistory.getHistory(sessionToken: sessionToken, vehicleId: vehicleId) { result in
            switch result {
                case .success(let data):
                    completion(.success(data: data!))
                case .failure(let error):
                    completion(.failure(data: error!))
            }
        }
    }
    
    func deleteVehicle(vehicleId: Int, completion: @escaping (Callback<Void, Int>) -> Void) {
        DeleteVehicleRequest.deleteVehicle(sessionToken: sessionToken, id: vehicleId) { result in
            switch result {
                case .success(_):
                    self.fetchVehicles()
                    completion(.success())
                case .failure(let error):
                    completion(.failure(data: error!))
            }
        }
    }
    
    func createVehicle(data: CreateVehicleRequest.RequestBody, completion: @escaping (Callback<Void, CreateVehicleRequest.ErrorType>) -> Void) {
        CreateVehicleRequest.createVehicle(sessionToken: sessionToken, requestBody: data) { result in
            switch result {
                case .success(_):
                    self.fetchVehicles()
                    completion(.success())
                case .failure(let error):
                    completion(.failure(data: error!))
            }
        }
    }
    
    func updateVehicle(data: RentCarModel, completion: @escaping (Callback<Void, Int>) -> Void) {
        UpdateVehicleRequest.updateVehicle(sessionToken: sessionToken, requestBody: data) { result in
            switch result {
                case .success(_):
                    self.fetchVehicles()
                    completion(.success())
                case .failure(let error):
                    completion(.failure(data: error!))
            }
        }
    }
    
}
