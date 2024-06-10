//
//  GetAllUsersRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 28/5/24.
//

import Foundation
import Alamofire

class GetAllUsersRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/user/list/all";
 
    static func getAllUsers(sessionToken: String, completion: @escaping (Callback<[UserModel], Int>) -> Void) {
        AF.request(url, method: .get, headers: [.authorization(bearerToken: sessionToken)])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseDecodable(of: [UserModel].self, decoder: jsonDecoder) { response in
                switch response.result {
                    case let .success(users):
                        completion(.success(data: users))
                    case let .failure(error):
                        print("Get all users request failed with error \(error) and response code \(error.responseCode ?? -1)")
                        completion(.failure(data: error.responseCode))
                }
            }
    }
    
}
