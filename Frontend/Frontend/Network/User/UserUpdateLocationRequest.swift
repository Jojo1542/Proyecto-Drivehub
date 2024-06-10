//
//  UserUpdateLocationRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 22/5/24.
//

import Foundation
import Alamofire

class UserUpdateLocationRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/user/location";
    
    static func updateLocation(sessionToken: String, body: RequestBody, completion: @escaping (Callback<Void, Int>) -> Void) {
        AF.request(url, method: .post, parameters: body, encoder: JSONParameterEncoder(encoder: jsonEncoder), headers: [.authorization(bearerToken: sessionToken)])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .response { response in
                switch response.result {
                    case .success(_):
                        completion(.success())
                    case let .failure(error):
                    print("Update location request failed with error \(error) and response code \(error.responseCode ?? -1)")
                        completion(.failure(data: error.responseCode))
                }
            }
    }
    
    struct RequestBody: Codable {
        var latitude: Double;
        var longitude: Double;
    }
    
}
