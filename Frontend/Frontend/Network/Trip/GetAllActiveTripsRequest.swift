//
//  GetAllActiveTripsRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 30/5/24.
//

import Foundation
import Alamofire

class GetAllActiveTripsRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/trip/active/all";
 
    static func getTrips(sessionToken: String, completion: @escaping (Callback<[TripModel], Int>) -> Void) {
        AF.request(url, method: .get, headers: [.authorization(bearerToken: sessionToken)])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .cURLDescription { description in
                print("Get Trip History request: \(description)")
            }.responseDecodable(of: [TripModel].self, decoder: jsonDecoder) { response in
                switch response.result {
                    case let .success(data):
                        completion(.success(data: data))
                    case let .failure(error):
                        completion(.failure(data: error.responseCode ?? 0))
                }
            }
    }
}
