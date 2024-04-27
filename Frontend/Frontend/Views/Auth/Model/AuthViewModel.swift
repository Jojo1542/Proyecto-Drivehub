//
//  AuthViewModel.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 12/4/24.
//

import Foundation
import Alamofire

class AuthViewModel: ObservableObject {
    
    @Published var sessionToken: String?
    @Published var currentUser: UserModel?
    
    func createAccount(email: String, password: String, firstName: String, lastName: String, callback: @escaping (Callback<Void, String>) -> ()) {
        RegisterRequest.createAccount(email: email, password: password, firstName: firstName, lastName: lastName, completion: { response in
            switch response {
                case .success(_):
                    callback(.success())
                case let .failure(error):
                    if (error == 409) {
                        callback(.failure(data: String(localized: "El correo electrónico introducido ya está registrado.")))
                    } else {
                        debugPrint("Hay un error desconocido registrando el usuario con status \(error ?? -1)")
                        callback(.failure(data: String(localized: "Ha ocurrido un error desconocido creando la cuenta. Contacte con un Administrador.")))
                    }
            }
        })
    }
    
    func login(email: String, password: String, callback: @escaping (Callback<Void, String>) -> ()) {
        LoginRequest.login(email: email, password: password, completion: { response in
            switch response {
                case let .success(response):
                    self.sessionToken = response?.accessToken;
                    self.updateUser();
                    callback(.success());
                case let .failure(error):
                    if (error == 401) {
                        callback(.failure(data: String(localized: "El usuario y/o contraseña son incorrecos.")))
                    } else {
                        debugPrint("Hay un error desconocido iniciando sesión con status \(error ?? -1)")
                        callback(.failure(data: String(localized: "Ha ocurrido un error desconocido iniciando sesión. Contacte con un Administrador.")))
                    }
            }
        })
    }
    
    func logout() {
        sessionToken = nil;
        
        // TODO: Hacer una petición al servidor para cerrar la sesión
    }

    func updateUser() {
        if (sessionToken != nil) {
            UserMeRequest.getUserInfo(sessionToken: sessionToken!) { response in
                switch response {
                    case let .success(userModel):
                        self.currentUser = userModel;
                        print("User \(userModel!.id) with email \(userModel!.email) loaded. Roles. \(userModel!.roles)")
                    case let .failure(error):
                        debugPrint("Hay un error desconocido cargando el usuario, status \(error ?? -1)")
                        self.currentUser = nil;
                }
            }
        } else {
            debugPrint("Updating while not logged in, removing current user...")
            self.currentUser = nil;
        }
    }
}
