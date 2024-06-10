//
//  FinalizeFleetContractRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 28/5/24.
//

import Foundation
import Alamofire

class FinalizeFleetContractRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/contract/fleet/{fleetId}/{contractId}";
    
    static func finalizeFleetContract(sessionToken: String, fleetId: Int, contractId: Int, completion: @escaping (Callback<Void, Int>) -> Void) {
        let url = url.replacingOccurrences(of: "{fleetId}", with: String(fleetId))
            .replacingOccurrences(of: "{contractId}", with: String(contractId));
        AF.request(url, method: .delete, headers: [.authorization(bearerToken: sessionToken)])
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                    case let .success(contract):
                        completion(.success())
                    case let .failure(error):
                        print("Finalize fleet contract request failed with error \(error) and response code \(error.responseCode ?? -1)")
                        completion(.failure(data: error.responseCode))
                }
            }
    }
    
}
