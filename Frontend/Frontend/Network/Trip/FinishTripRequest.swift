//
//  FinishTripRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 23/5/24.
//

import Foundation
import Alamofire

class FinishTripRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/trip/driver/active/finish?cancel={cancelled}";
    
    static func finishTrip(sessionToken: String, cancelledByDriver: Bool, completion: @escaping (Callback<Void, Int>) -> Void) {
        AF.request(url.replacingOccurrences(of: "{cancelled}", with: "\(cancelledByDriver)"), method: .post, headers: [.authorization(bearerToken: sessionToken)])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .cURLDescription { description in
                print("Cancel Trip request: \(description)")
            }.response { response in
                switch response.result {
                    case .success:
                        completion(.success());
                    case let .failure(error):
                        completion(.failure(data: error.responseCode ?? 0));
                }
            }
    }
    
}
