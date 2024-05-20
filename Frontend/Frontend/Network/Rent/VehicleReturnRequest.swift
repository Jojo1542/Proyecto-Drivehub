//
//  VehicleReturnRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 17/5/24.
//

import Foundation
import Alamofire

class VehicleReturnRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/rent/return/{id}";
    
    static func returnVehicle(sessionToken: String, vehicleId: Int, completion: @escaping (Callback<Void, ErrorType>) -> Void) {
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
                        print("Return vehicle request failed with error \(error) and response code \(error.responseCode ?? -1)")
                        let problem = decodeProblemDetailsFromResponse(request: response);
                        completion(.failure(data: ErrorType(rawValue: problem.type) ?? .UNKNOWN))
                }
            }
    }
    
    enum ErrorType: String, CaseIterable, Codable, Hashable {
        case USER_DOES_NOT_HAVE_ACTIVE_RENT = "USER_DOES_NOT_HAVE_ACTIVE_RENT"
        case VEHICLE_NOT_FOUND = "VEHICLE_NOT_FOUND"
        case VEHICLE_NOT_RENTED_BY_USER = "VEHICLE_NOT_RENTED_BY_USER"
        case UNKNOWN = "UNKNOWN"
    }
    

}
