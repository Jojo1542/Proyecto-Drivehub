//
//  CreateFleetRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 21/5/24.
//

import Foundation
import Alamofire

class CreateFleetRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/fleet/create";
    
    static func createFleet(sessionToken: String, data: RequestBody, completion: @escaping (Callback<Void, ErrorType>) -> Void) {
        AF.request(url, method: .post, parameters: data, encoder: JSONParameterEncoder(encoder: jsonEncoder), headers: [.authorization(bearerToken: sessionToken)])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .cURLDescription { description in
                print("Create Fleet request: \(description)")
            }.response { response in
                switch response.result {
                    case .success:
                        completion(.success(data: ()))
                    case let .failure(error):
                        let errorType = ErrorType(rawValue: error.responseCode?.description ?? "UNKNOWN") ?? .UNKNOWN
                        completion(.failure(data: errorType))
                }
            }
    }
    
    struct RequestBody: Codable {
        let name: String
        let CIF: String
        let vehicleType: String
    }
    
    enum ErrorType: String, CaseIterable, Codable, Hashable {
        case CIF_ALREADY_EXISTS = "CIF_ALREADY_EXISTS"
        case UNKNOWN = "UNKNOWN"
    }
}
