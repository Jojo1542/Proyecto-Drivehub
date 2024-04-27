//
//  RegisterRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 25/4/24.
//

import Foundation
import Alamofire

class RegisterRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/auth/register";
    
    static func createAccount(email: String, password: String, firstName: String, lastName: String, completion: @escaping (Callback<Void, Int>) -> Void) {
        AF.request(url, method: .post, parameters:
                    ["email": email, "password": password, "firstName": firstName, "lastName": lastName]
        ).validate(statusCode: 200..<300)
        .validate(contentType: ["application/json"])
        .cURLDescription { description in
            debugPrint("Register request: " + description)
        }
        .response { response in
            switch response.result {
                case .success:
                    completion(.success())
                case let .failure(error):
                    completion(.failure(data: error.responseCode))
            }
        }
        
    }
}
