//
//  GetShipmentLocationRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 26/5/24.
//

import Foundation
import Alamofire

class GetShipmentLocationRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/ship/{id}/location";

    static func getShipmentLocation(sessionToken: String, id: Int, completion: @escaping (Callback<UserLocationModel, Int>) -> Void) {
        AF.request(url.replacingOccurrences(of: "{id}", with: "\(id)"), headers: [.authorization(bearerToken: sessionToken)])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .cURLDescription { description in
                print("Get Shipment Location request: \(description)")
            }.responseDecodable(of: UserLocationModel.self, decoder: jsonDecoder) { response in
                switch response.result {
                    case .success(let result):
                        completion(.success(data: result))
                    case let .failure(error):
                        print("Get Shipment Location request failed with error \(error) and response code \(error.responseCode ?? -1)")
                        completion(.failure(data: error.responseCode))
                }
            }
    }
    
}
