//
//  GetShipmentDetailsRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 21/5/24.
//

import Foundation
import Alamofire

class GetShipmentDetailsRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/ship/{id}";
    
    static func getShipmentDetails(sessionToken: String, id: Int, completion: @escaping (Callback<ShipmentModel, Int>) -> Void) {
        AF.request(url.replacingOccurrences(of: "{id}", with: "\(id)"), headers: [.authorization(bearerToken: sessionToken)])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .cURLDescription { description in
                print("Get Shipment Details request: \(description)")
            }.responseDecodable(of: ShipmentModel.self, decoder: jsonDecoder) { response in
                switch response.result {
                    case .success(let result):
                        completion(.success(data: result))
                    case let .failure(error):
                        print("Get Shipment Details request failed with error \(error) and response code \(error.responseCode ?? -1)")
                        completion(.failure(data: error.responseCode))
                }
            }
    }
}
