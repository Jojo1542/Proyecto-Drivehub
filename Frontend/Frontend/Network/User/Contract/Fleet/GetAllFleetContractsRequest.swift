//
//  GetAllFleetContractsRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 28/5/24.
//

import Foundation
import Alamofire

class GetAllFleetContractsRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/contract/fleet/{fleetId}/all";
 
    static func getAllFleetContracts(sessionToken: String, fleetId: Int, completion: @escaping (Callback<[ContractModel], Int>) -> Void) {
        let url = url.replacingOccurrences(of: "{fleetId}", with: String(fleetId));
        AF.request(url, method: .get, headers: [.authorization(bearerToken: sessionToken)])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseDecodable(of: [ContractModel].self, decoder: jsonDecoder) { response in
                switch response.result {
                    case let .success(contracts):
                        completion(.success(data: contracts))
                    case let .failure(error):
                        print("Get all fleet contracts request failed with error \(error) and response code \(error.responseCode ?? -1)")
                        completion(.failure(data: error.responseCode))
                }
            }
    }
    
}
