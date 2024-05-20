//
//  UserMeRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 26/4/24.
//

import Foundation
import Alamofire

class UserMeRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/user/me";
    
    static func getUserInfo(sessionToken: String, completion: @escaping (Callback<UserModel, Int>) -> Void) {
        AF.request(url, headers: [.authorization(bearerToken: sessionToken)])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .cURLDescription { description in
                print("Me user request: \(description)")
            }.responseDecodable(of: UserModel.self, decoder: jsonDecoder) { response in
                switch response.result {
                    case .success(let user):
                        completion(.success(data: user))
                    case let .failure(error):
                        print("Me user request failed with error \(error) and response code \(error.responseCode ?? -1)")
                        completion(.failure(data: error.responseCode))
                }
            }
    }
}
