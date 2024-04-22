//
//  AuthViewModel.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 12/4/24.
//

import Foundation
import Alamofire

class AuthViewModel: ObservableObject {
    
    // Base url de la API
    let baseUrl = "http://192.168.1.49:8080";
    
    @Published var sessionToken: String?
    @Published var currentUser: UserModel?
    
    func createAccount(email: String, password: String, firstName: String, lastName: String, callback: @escaping (Callback<Void, String>) -> ()) {
        AF.request("\(baseUrl)/auth/register", method: .post, parameters:
                    ["email": email, "password": password, "firstName": firstName, "lastName": lastName]
        ).validate(statusCode: 200..<300)
        .validate(contentType: ["application/json"])
        .cURLDescription { description in
            print("Register request: " + description)
        }
        .response { response in
            switch response.result {
                case .success:
                    callback(.success())
                case let .failure(error):
                    if let data = response.data, let errorString = String(data: data, encoding: .utf8) {
                        callback(.failure(data: errorString))
                    } else {
                        callback(.failure(data: error.failureReason ?? "Error desconocido"))
                    }
            }
        }
    }
    
    func login(email: String, password: String, callback: @escaping (Callback<Void, String>) -> ()) {
        AF.request("\(baseUrl)/auth/login", method: .post, headers: [.authorization(username: email, password: password)])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .cURLDescription { description in
                print("Login request: " + description)
            }.responseDecodable(of: LoginResponse.self) { response in
                switch response.result {
                    case .success(let loginResponse):
                        self.sessionToken = loginResponse.accessToken // Token de inicio de sesión
                        self.updateUser() // Actualizar el usuario
                        callback(.success())
                    case let .failure(error):
                        if let data = response.data, let errorString = String(data: data, encoding: .utf8) {
                            callback(.failure(data: errorString))
                        } else {
                            // Manejo genérico de errores de red u otro
                            callback(.failure(data: error.failureReason ?? "Error desconocido"))
                        }
                }
            }
    }
    
    func logout() {
        sessionToken = nil;
        currentUser = nil;
        
        // TODO: Hacer una petición al servidor para cerrar la sesión
    }

    func updateUser() {
        if (sessionToken != nil) {
            AF.request("\(baseUrl)/user/me", headers: [.authorization(bearerToken: sessionToken!)])
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .cURLDescription { description in
                    print("Update user request: " + description)
                }.responseDecodable(of: UserModel.self) { response in
                    switch response.result {
                        case .success(let user):
                            self.currentUser = user
                        case let .failure(error):
                            print("Error updating user: \(error)")
                    }
                }
            
        } else {
            print("Updating while not logged in, ignoring...")
        }
    }
}
