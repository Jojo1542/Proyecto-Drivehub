//
//  DeleteVehicleRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 21/5/24.
//

import Foundation
import Alamofire

class DeleteVehicleRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/vehicles/{id}";
    
    static func deleteVehicle(sessionToken: String, id: Int, completion: @escaping (Callback<Void, Int>) -> Void) {
        AF.request(url.replacingOccurrences(of: "{id}", with: "\(id)"), method: .delete, headers: [.authorization(bearerToken: sessionToken)])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .cURLDescription { description in
                print("Delete Vehicle request: \(description)")
            }.response { response in
                switch response.result {
                    case .success(let result):
                        completion(.success())
                    case let .failure(error):
                        print("Delete Vehicle request failed with error \(error) and response code \(error.responseCode ?? -1)")
                        completion(.failure(data: error.responseCode))
                }
            }
    }
    
}
