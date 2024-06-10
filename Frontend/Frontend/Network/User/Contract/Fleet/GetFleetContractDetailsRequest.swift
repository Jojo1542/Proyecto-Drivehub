//
//  GetFleetContractDetailsRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 28/5/24.
//

import Foundation
import Alamofire

class GetFleetContractDetailsRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/contract/fleet/{fleetId}/{contractId}";
    
    static func getFleetContractDetails(sessionToken: String, fleetId: Int, contractId: Int, completion: @escaping (Callback<ContractModel, Int>) -> Void) {
        let url = url.replacingOccurrences(of: "{fleetId}", with: String(fleetId))
            .replacingOccurrences(of: "{contractId}", with: String(contractId));
        AF.request(url, method: .get, headers: [.authorization(bearerToken: sessionToken)])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseDecodable(of: ContractModel.self, decoder: jsonDecoder) { response in
                switch response.result {
                    case let .success(contract):
                        completion(.success(data: contract))
                    case let .failure(error):
                        print("Get fleet contract details request failed with error \(error) and response code \(error.responseCode ?? -1)")
                        completion(.failure(data: error.responseCode))
                }
            }
    }
}
