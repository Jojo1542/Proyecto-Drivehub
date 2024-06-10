//
//  CreateTripRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 23/5/24.
//

import Foundation
import Alamofire


class CreateTripRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/trip/start/{id}?sendPackage={sendPackage}";
    
    static func startTrip(sessionToken: String, draftId: String, sendPackage: Bool, completion: @escaping (Callback<TripModel, ErrorType>) -> Void) {
        AF.request(url.replacingOccurrences(of: "{id}", with: draftId).replacingOccurrences(of: "{sendPackage}", with: "\(sendPackage)"), method: .post, headers: [.authorization(bearerToken: sessionToken)])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .cURLDescription { description in
                print("Create Trip request: \(description)")
            }.responseDecodable(of: TripModel.self, decoder: jsonDecoder) { response in
                switch response.result {
                    case let .success(data):
                        completion(.success(data: data))
                    case let .failure(error):
                        print("Error starting trip: \(error)")
                        let errorType = ErrorType(rawValue: error.responseCode?.description ?? "UNKNOWN") ?? .UNKNOWN
                        completion(.failure(data: errorType))
                }
            }
    }
    
    enum ErrorType: String, CaseIterable, Codable, Hashable {
        case INVALID_DISTANCE_BETWEEN = "INVALID_DISTANCE_BETWEEN"
        case INVALID_PRICE = "INVALID_PRICE"
        case INSSUFICIENT_FUNDS = "INSSUFICIENT_FUNDS"
        case ACTIVE_TRIP_EXISTS = "ACTIVE_TRIP_EXISTS"
        case UNKNOWN = "UNKNOWN"
    }
    
}
