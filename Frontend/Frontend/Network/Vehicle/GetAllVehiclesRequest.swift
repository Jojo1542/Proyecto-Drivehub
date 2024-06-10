//
//  GetAllVehiclesRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 21/5/24.
//

import Foundation
import Alamofire

class GetAllVehiclesRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/vehicles/all";
    
    static func getVehicles(sessionToken: String, completion: @escaping (Callback<[RentCarModel], Int>) -> Void) {
        AF.request(url, headers: [.authorization(bearerToken: sessionToken)])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .cURLDescription { description in
                print("Avaiable Vehicles request: \(description)")
            }.responseDecodable(of: [RentCarModel].self, decoder: jsonDecoder) { response in
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

