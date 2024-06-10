//
//  GetFleetShipmentsRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 21/5/24.
//

import Foundation
import Alamofire

class GetFleetShipmentsRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/ship/list/fleet/{id}";
    
    static func getAllShipment(sessionToken: String, fleetId: Int, completion: @escaping (Callback<[ShipmentModel], Int>) -> Void) {
        AF.request(url.replacingOccurrences(of: "{id}", with: "\(fleetId)"), headers: [.authorization(bearerToken: sessionToken)])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .cURLDescription { description in
                print("Assigned Shipment request: \(description)")
            }.responseDecodable(of: [ShipmentModel].self, decoder: jsonDecoder) { response in
                switch response.result {
                case .success(let result):
                    completion(.success(data: result))
                case let .failure(error):
                    print("Fleet Shipment request failed with error \(error) and response code \(error.responseCode ?? -1)")
                    completion(.failure(data: error.responseCode))
                }
            }
    }
    
}
