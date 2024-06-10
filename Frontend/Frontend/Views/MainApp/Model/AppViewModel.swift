//
//  MainAppViewModel.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 26/4/24.
//

import Foundation

class AppViewModel: ObservableObject {
    
    private var authViewModel: AuthViewModel;
    @Published var tripHistory: [TripModel] = [];
    @Published var contracts: [ContractModel] = [];
    
    init(authViewModel: AuthViewModel) {
        self.authViewModel = authViewModel
    }
    
    func fetchTripHistory() {
        GetTripHistoryRequest.getTripHistory(sessionToken: getSessionToken()) { result in
            switch result {
            case .success(let data):
                self.tripHistory = data!;
            case .failure(let error):
                print("Error updating trip history \(error ?? 0)");
            }
        }
    }
    
    func fetchContracts() {
        GetOwnContractsRequest.getOwnContracts(sessionToken: getSessionToken()) { result in
            switch result {
            case .success(let data):
                self.contracts = data!;
            case .failure(let error):
                print("Error updating contracts \(error ?? 0)");
            }
        }
    }
    
    public func updatePassword(newPassword: String, completion: @escaping (Callback<Void, Void>) -> Void) {
        let request = UserUpdateRequest.RequestBody(password: newPassword);
        
        UserUpdateRequest.updateUser(sessionToken: getSessionToken(), body: request, completion: { response in
            switch response {
                case .success(_):
                    completion(.success())
                case .failure(_):
                    completion(.failure())
            }
        });
    }
    
    public func saveAndUpdateUser(completion: @escaping (Callback<Void, UserUpdateRequest.ErrorType>) -> Void) {
        let actualUser = getUser();
        
        let request = UserUpdateRequest.RequestBody(
            firstName: actualUser.firstName,
            lastName: actualUser.lastName,
            phone: actualUser.phone,
            email: actualUser.email,
            dni: actualUser.dni,
            birthDate: actualUser.birthDate
        );
        
        UserUpdateRequest.updateUser(sessionToken: getSessionToken(), body: request, completion: { response in
            switch response {
            case .success(_):
                self.authViewModel.updateUser(); // Actualiza el usuario en la aplicación
                completion(.success())
            case .failure(let error):
                completion(.failure(data: error))
            }
        });
    }
    
    public func addDriverLicense(driverLicense: UserModel.DriverLicense, completion: @escaping (Callback<Void, AddDriverLicenseRequest.ErrorType>) -> Void) {
        AddDriverLicenseRequest.addDriverLicense(sessionToken: getSessionToken(), driverLicense: driverLicense, completion: { response in
            switch response {
                case .success(_):
                    self.authViewModel.updateUser(); // Actualiza el usuario en la aplicación
                    completion(.success())
                case .failure(let error):
                    completion(.failure(data: error))
                }
        });
    }
    
    public func deleteDriverLicense(licenseId: String, completion: @escaping (Callback<Void, RemoveDriverLicenseRequest.ErrorType>) -> Void) {
        RemoveDriverLicenseRequest.removeDriverLicense(sessionToken: getSessionToken(), driverLicenseId: licenseId, completion: { response in
            switch response {
                case .success(_):
                    self.authViewModel.updateUser(); // Actualiza el usuario en la aplicación
                    completion(.success())
                case .failure(let error):
                    completion(.failure(data: error))
            }
        });
    }
    
    public func updateLocationToServer(latitude: Double, longitude: Double) {
        let data = UserUpdateLocationRequest.RequestBody(latitude: latitude, longitude: longitude);
        
        UserUpdateLocationRequest.updateLocation(sessionToken: getSessionToken(), body: data, completion: { response in
            if case .failure(let error) = response {
                print("Error updating location \(error ?? 0)");
            }
        });
    }
    
    public func updateUser() {
        authViewModel.updateUser();
    }
    
    public func getUser() -> UserModel {
        return authViewModel.currentUser!;
    }
    
    public func getSessionToken() -> String {
        return authViewModel.sessionToken ?? "";
    }
    
}
