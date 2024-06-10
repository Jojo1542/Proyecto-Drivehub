//
//  GetVehicleRentHistory.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 21/5/24.
//

import Foundation
import Alamofire

class GetVehicleRentHistory {
 
    private static let url = "\(NetworkConfiguration.baseUrl)/vehicles/{id}/history";
    
    static func getHistory(sessionToken: String, vehicleId: Int64, completion: @escaping (Callback<[UserRentHistoryModel], Int>) -> Void) {
        AF.request(url.replacingOccurrences(of: "{id}", with: vehicleId.description), headers: [.authorization(bearerToken: sessionToken)])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .cURLDescription { description in
                print("Avaiable Vehicles request: \(description)")
            }.responseDecodable(of: [UserRentHistoryModel].self, decoder: jsonDecoder) { response in
                switch response.result {
                    case .success(let result):
                        completion(.success(data: result))
                    case let .failure(error):
                        print("Me user request failed with error \(error) and response code \(error.responseCode ?? -1)")
                        completion(.failure(data: error.responseCode))
                }
            }
    }
    
}
