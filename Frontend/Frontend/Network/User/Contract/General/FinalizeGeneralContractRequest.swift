//
//  FinalizeContractRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 28/5/24.
//

import Foundation
import Alamofire

class FinalizeGeneralContractRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/contract/general/{contractId}";
 
    static func finalizeGeneralContract(sessionToken: String, contractId: Int, completion: @escaping (Callback<Void, Int>) -> Void) {
        let url = url.replacingOccurrences(of: "{contractId}", with: String(contractId));
        AF.request(url, method: .delete, headers: [.authorization(bearerToken: sessionToken)])
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                    case let .success(contract):
                        completion(.success())
                    case let .failure(error):
                        print("Finalize general contract request failed with error \(error) and response code \(error.responseCode ?? -1)")
                        completion(.failure(data: error.responseCode))
                }
            }
    }
    
}
