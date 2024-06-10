//
//  GetAllShipmentRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 21/5/24.
//

import Foundation
import Alamofire

class GetAllShipmentRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/ship/all";
    
    static func getAllShipment(sessionToken: String, completion: @escaping (Callback<[ShipmentModel], Int>) -> Void) {
        AF.request(url, headers: [.authorization(bearerToken: sessionToken)])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .cURLDescription { description in
                print("Assigned Shipment request: \(description)")
            }.responseDecodable(of: [ShipmentModel].self, decoder: jsonDecoder) { response in
                switch response.result {
                    case .success(let result):
                        completion(.success(data: result))
                    case let .failure(error):
                        print("Assigned Shipment request failed with error \(error) and response code \(error.responseCode ?? -1)")
                        completion(.failure(data: error.responseCode))
                }
            }
    }
    
}
