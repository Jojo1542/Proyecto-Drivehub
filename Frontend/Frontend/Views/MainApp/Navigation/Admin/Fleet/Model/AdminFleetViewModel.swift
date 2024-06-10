//
//  AdminFleetViewModel.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 21/5/24.
//

import Foundation

class AdminFleetViewModel: ObservableObject {
    
    var appViewModel: AppViewModel;
    var fleetId: Int?
    var superAdmin = false;
    
    @Published var fleets: [FleetModel] = [];
    @Published var drivers: [UserModel] = [];
    @Published var contracts: [ContractModel] = [];
    @Published var allUsers: [UserModel] = [];
    
    private var sessionToken: String {
        return appViewModel.getSessionToken()
    }
    
    public init(appModel: AppViewModel) {
        self.appViewModel = appModel;
    }
    
    public func fetchAllUsers() {
        GetAllUsersRequest.getAllUsers(sessionToken: sessionToken) { result in
            switch result {
            case .success(let data):
                self.allUsers = data!;
            case .failure(let error):
                print("Fetch users failed with error \(error!)")
            }
        }
    }
    
    public func fetchFleets(superAdmin: Bool = false) {
        if superAdmin {
            fetchAdminFleets();
        } else {
            fetchOwnFleets();
        }
        
        self.superAdmin = superAdmin;
    }
    
    public func fetchAdminFleets() {
        GetAllFleetRequest.getAllFleets(sessionToken: sessionToken) { result in
            switch result {
                case .success(let data):
                    self.fleets = data!;
                case .failure(let error):
                    print("Fetch admin fleets failed with error \(error!)")
            }
        }
    }
    
    public func fetchOwnFleets() {
        GetAdminFleetsRequest.getAdminFleets(sessionToken: sessionToken) { result in
            switch result {
                case .success(let data):
                    self.fleets = data!;
                case .failure(let error):
                    print("Fetch own fleets failed with error \(error!)")
            }
        }
    }
    
    public func createFleet(data: CreateFleetRequest.RequestBody, completion: @escaping (Callback<Void, CreateFleetRequest.ErrorType>) -> Void) {
        CreateFleetRequest.createFleet(sessionToken: sessionToken, data: data) { result in
            switch result {
                case .success:
                    self.fetchFleets(superAdmin: self.superAdmin)
                    completion(.success(data: ()))
                case .failure(let error):
                    completion(.failure(data: error))
            }
        }
    }
    
    public func getFleetDrivers(fleetId: String, completion: @escaping (Callback<[UserModel], Int>) -> Void) {
        GetFleetDriversRequest.getFleetDrivers(sessionToken: sessionToken, fleetId: fleetId) { result in
            switch result {
                case .success(let data):
                    completion(.success(data: data!))
                case .failure(let error):
                    completion(.failure(data: error))
            }
        }
    }
    
    // Funciones de obtener todos los conductores
    public func fetchDrivers() {
        GetFleetDriversRequest.getFleetDrivers(sessionToken: sessionToken, fleetId: "\(fleetId ?? -1)") { result in
            switch result {
                case .success(let data):
                    self.drivers = data!;
                case .failure(let error):
                    print("Fetch drivers failed with error \(error!)")
            }
        }
    }
    
    public func fetchContracts() {
        GetAllFleetContractsRequest.getAllFleetContracts(sessionToken: sessionToken, fleetId: fleetId!) { result in
            switch result {
            case .success(let data):
                self.contracts = data!;
                self.contracts.forEach({ contract in
                    contract.driverData = self.drivers.first(where: { user in user.id == contract.driver });
                });
            case .failure(let error):
                print("Fetch contracts failed with error \(error!)")
            }
        }
    }
    
    public func createContract(data: CreateContractRequest.RequestBody, completion: @escaping (Callback<Void, Int>) -> Void) {
        CreateContractRequest.createContract(sessionToken: sessionToken, body: data) { result in
            switch result {
            case .success:
                self.fetchContracts()
                completion(.success())
            case .failure(let error):
                completion(.failure(data: error))
            }
        }
    }
    
    public func finalizeContract(contractId: Int, completion: @escaping (Callback<Void, Int>) -> Void) {
        FinalizeFleetContractRequest.finalizeFleetContract(sessionToken: sessionToken, fleetId: fleetId!, contractId: contractId) { result in
            switch result {
            case .success:
                self.fetchContracts()
                completion(.success())
            case .failure(let error):
                completion(.failure(data: error))
            }
        }
    }
}
