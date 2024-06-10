//
//  GetOwnContractsRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 28/5/24.
//

import Foundation
import Alamofire

class GetOwnContractsRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/contract/own/all";
    
    static func getOwnContracts(sessionToken: String, completion: @escaping (Callback<[ContractModel], Int>) -> Void) {
        AF.request(url, method: .get, headers: [.authorization(bearerToken: sessionToken)])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseDecodable(of: [ContractModel].self, decoder: jsonDecoder) { response in
                switch response.result {
                    case let .success(contracts):
                        completion(.success(data: contracts))
                    case let .failure(error):
                        print("Get own contracts request failed with error \(error) and response code \(error.responseCode ?? -1)")
                        completion(.failure(data: error.responseCode))
                }
            }
    }
    
}
