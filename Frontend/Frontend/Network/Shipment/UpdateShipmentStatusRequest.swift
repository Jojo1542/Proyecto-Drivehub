//
//  UpdateShipmentStatusRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 21/5/24.
//

import Foundation
import Alamofire

class UpdateShipmentStatusRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/ship/status/{id}";
    
    static func updateShipmentStatus(sessionToken: String, id: Int, requestBody: RequestBody, completion: @escaping (Callback<Void, Int>) -> Void) {
        AF.request(url.replacingOccurrences(of: "{id}", with: "\(id)"), method: .put, parameters: requestBody, encoder: JSONParameterEncoder(encoder: jsonEncoder), headers: [.authorization(bearerToken: sessionToken)])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .cURLDescription { description in
                print("Update Shipment Status request: \(description)")
            }.response { response in
                switch response.result {
                    case .success(let result):
                        completion(.success())
                    case let .failure(error):
                        print("Update Shipment Status request failed with error \(error) and response code \(error.responseCode ?? -1)")
                        completion(.failure(data: error.responseCode))
                }
            }
    }
    
    struct RequestBody: Codable {
        let updateDate: Date
        let status: String
        let description: String?
    }
    
}
