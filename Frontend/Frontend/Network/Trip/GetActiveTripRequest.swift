//
//  GetActiveTripRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 23/5/24.
//

import Foundation
import Alamofire

class GetActiveTripRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/trip/active";
 
    static func getActiveTrip(sessionToken: String, completion: @escaping (Callback<TripModel, Int>) -> Void) {
        AF.request(url, method: .get, headers: [.authorization(bearerToken: sessionToken)])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .cURLDescription { description in
                print("Get Active Trip request: \(description)")
            }.responseDecodable(of: TripModel.self, decoder: jsonDecoder) { response in
                switch response.result {
                    case let .success(data):
                        completion(.success(data: data))
                    case let .failure(error):
                        print("Get active trip request failed with error \(error) and response code \(error.responseCode ?? -1)")
                        completion(.failure(data: error.responseCode ?? 0))
                }
            }
    }
    
}
