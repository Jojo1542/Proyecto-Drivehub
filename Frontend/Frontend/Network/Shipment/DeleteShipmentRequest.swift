//
//  DeleteShipmentRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 21/5/24.
//

import Foundation
import Alamofire

class DeleteShipmentRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/ship/{id}";
 
    static func deleteShipment(sessionToken: String, id: Int, completion: @escaping (Callback<Int, Int>) -> Void) {
        AF.request(url, method: .delete, headers: [.authorization(bearerToken: sessionToken)])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .cURLDescription { description in
                print("Delete Shipment request: \(description)")
            }.response { response in
                switch response.result {
                    case .success:
                        completion(.success(data: 200))
                    case let .failure(error):
                        print("Delete Shipment request failed with error \(error) and response code \(error.responseCode ?? -1)")
                        completion(.failure(data: error.responseCode))
                }
            }
    }
    
}
