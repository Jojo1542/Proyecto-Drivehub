//
//  MainAppViewModel.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 26/4/24.
//

import Foundation

class AppViewModel: ObservableObject {
    
    private var authViewModel: AuthViewModel;
    
    init(authViewModel: AuthViewModel) {
        self.authViewModel = authViewModel
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
            case .success(let user):
                self.authViewModel.updateUser(); // Actualiza el usuario en la aplicación
                completion(.success())
            case .failure(let error):
                completion(.failure(data: error))
            }
        });
    }
    
    public func getUser() -> UserModel {
        return authViewModel.currentUser!;
    }
    
    public func getSessionToken() -> String {
        return authViewModel.sessionToken!;
    }
    
}
