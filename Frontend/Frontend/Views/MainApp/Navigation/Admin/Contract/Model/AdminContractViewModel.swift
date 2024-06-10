//
//  AdminContractViewModel.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 28/5/24.
//

import Foundation

class AdminContractViewModel: ObservableObject {
    private var appViewModel: AppViewModel;
    
    @Published var users: [UserModel] = []
    @Published var contracts: [ContractModel] = []
    
    private var sessionToken: String {
        return appViewModel.getSessionToken()
    }
    
    public init(appModel: AppViewModel) {
        self.appViewModel = appModel;
        
        fetchUsers() // Cargar directamente los usuarios
    }
    
    public func fetchUsers() {
        GetAllUsersRequest.getAllUsers(sessionToken: sessionToken) { result in
            switch result {
            case .success(let data):
                self.users = data!;
            case .failure(let error):
                print("Fetch users failed with error \(error!)")
            }
        }
    }
    
    public func fetchContracts() {
        GetAllGeneralContractsRequest.getAllGeneralContracts(sessionToken: sessionToken) { result in
            switch result {
            case .success(let data):
                self.contracts = data!;
                self.contracts.forEach({ contract in
                    contract.driverData = self.users.first(where: { user in user.id == contract.driver });
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
        FinalizeGeneralContractRequest.finalizeGeneralContract(sessionToken: sessionToken, contractId: contractId) { result in
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
