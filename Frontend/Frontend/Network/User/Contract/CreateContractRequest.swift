//
//  CreateContractRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 28/5/24.
//

import Foundation
import Alamofire

class CreateContractRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/contract/create";
 
    static func createContract(sessionToken: String, body: RequestBody, completion: @escaping (Callback<ContractModel, Int>) -> Void) {
        AF.request(url, method: .post, parameters: body, encoder: JSONParameterEncoder(encoder: jsonEncoder), headers: [.authorization(bearerToken: sessionToken)])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseDecodable(of: ContractModel.self) { response in
                switch response.result {
                    case let .success(contract):
                        completion(.success(data: contract))
                    case let .failure(error):
                        print("Create contract request failed with error \(error) and response code \(error.responseCode ?? -1)")
                        completion(.failure(data: error.responseCode))
                }
            }
    }
    
    struct RequestBody: Encodable {
        var driverId: Int;
        var startDate: Date;
        var endDate: Date;
        var salary: Double;
        var fleetId: Int?;
    }
    
}
