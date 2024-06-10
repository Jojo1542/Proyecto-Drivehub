//
//  GetContractDetailsRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 28/5/24.
//

import Foundation
import Alamofire

class GetContractDetailsRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/contract/general/{contractId}";
 
    static func getContractDetails(sessionToken: String, contractId: Int, completion: @escaping (Callback<ContractModel, Int>) -> Void) {
        let url = url.replacingOccurrences(of: "{contractId}", with: String(contractId));
        AF.request(url, method: .get, headers: [.authorization(bearerToken: sessionToken)])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseDecodable(of: ContractModel.self, decoder: jsonDecoder) { response in
                switch response.result {
                    case let .success(contract):
                        completion(.success(data: contract))
                    case let .failure(error):
                        print("Get contract details request failed with error \(error) and response code \(error.responseCode ?? -1)")
                        completion(.failure(data: error.responseCode))
                }
            }
    }
    
}
