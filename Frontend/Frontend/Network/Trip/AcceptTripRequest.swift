//
//  AcceptTripRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 28/5/24.
//

import Foundation
import Alamofire

class AcceptTripRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/trip/driver/accept/{tripId}";
    
    static func acceptTrip(sessionToken: String, tripId: Int, completion: @escaping (Callback<Void, Int>) -> Void) {
        AF.request(url.replacingOccurrences(of: "{tripId}", with: "\(tripId)"), method: .post, headers: [.authorization(bearerToken: sessionToken)])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .cURLDescription { description in
                print("Accept Trip request: \(description)")
            }.response { response in
                switch response.result {
                    case .success:
                        completion(.success(data: ()))
                    case let .failure(error):
                        completion(.failure(data: error.responseCode ?? 0))
                }
            }
    }
    
}
