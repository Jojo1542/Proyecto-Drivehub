//
//  VehicleRentRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 17/5/24.
//

import Foundation
import Alamofire

class VehicleRentRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/rent/take/{id}";
    
    static func rentVehicle(sessionToken: String, vehicleId: Int, completion: @escaping (Callback<Void, ErrorType>) -> Void) {
        let url = url.replacingOccurrences(of: "{id}", with: String(vehicleId))
        AF.request(url, method: .post, headers: [.authorization(bearerToken: sessionToken)])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .cURLDescription { description in
                print("Vehicle Rent request: \(description)")
            }.response { response in
                switch response.result {
                    case .success:
                        completion(.success(data: ()))
                    case let .failure(error):
                        print("Rent vehicle request failed with error \(error) and response code \(error.responseCode ?? -1)")
                        let problem = decodeProblemDetailsFromResponse(request: response);
                        completion(.failure(data: ErrorType(rawValue: problem.type) ?? .UNKNOWN))
                }
            }
    }
    
    enum ErrorType: String, CaseIterable, Codable, Hashable {
        case USER_ALREADY_HAS_RENT = "USER_ALREADY_HAS_RENT"
        case VEHICLE_NOT_AVAILABLE = "VEHICLE_NOT_AVAILABLE"
        case USER_DOES_NOT_HAVE_LICENSE = "USER_DOES_NOT_HAVE_LICENSE"
        case USER_CANT_AFFORD_RENT = "USER_CANT_AFFORD_RENT"
        case UNKNOWN = "UNKNOWN"
    }
    
    
}
