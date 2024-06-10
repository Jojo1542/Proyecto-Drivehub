//
//  GetFleetDriversRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 21/5/24.
//

import Foundation
import Alamofire

class GetFleetDriversRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/fleet/{id}/drivers";
    
    static func getFleetDrivers(sessionToken: String, fleetId: String, completion: @escaping (Callback<[UserModel], Int>) -> Void) {
        let url = url.replacingOccurrences(of: "{id}", with: fleetId);
        
        AF.request(url, method: .get, headers: [.authorization(bearerToken: sessionToken)])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseDecodable(of: [UserModel].self, decoder: jsonDecoder) { response in
                switch response.result {
                    case .success(let data):
                        completion(.success(data: data))
                    case let .failure(error):
                        completion(.failure(data: error.responseCode))
                }
            }
    }
    
}
