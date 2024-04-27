//
//  LoginRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 25/4/24.
//

import Foundation
import Alamofire

class LoginRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/auth/login";
    
    static func login(email: String, password: String, completion: @escaping (Callback<Response, Int>) -> Void) {
        AF.request(url, method: .post, headers: [.authorization(username: email, password: password)])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .cURLDescription { description in
                debugPrint("Login request: \(description)")
            }.responseDecodable(of: Response.self) { response in
                switch response.result {
                    case .success(let loginResponse):
                        completion(.success(data: loginResponse))
                    case let .failure(error):
                        completion(.failure(data: error.responseCode))
                }
            }
    }
    
    struct Response: Decodable {
        let accessToken: String
    }
}
