//
//  UserUpdateBalanceRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 30/5/24.
//

import Foundation
import Alamofire

class UserUpdateBalanceRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/user/update/balance/{id}";
 
    static func updateBalance(sessionToken: String, userId: Int, body: RequestBody, completion: @escaping (Callback<Void, Int>) -> Void) {
        let url = url.replacingOccurrences(of: "{id}", with: String(userId))
        AF.request(url, method: .post, parameters: body, encoder: JSONParameterEncoder(encoder: jsonEncoder), headers: [.authorization(bearerToken: sessionToken)])
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                    case .success:
                        completion(.success(data: ()))
                    case let .failure(error):
                        print("Update balance request failed with error \(error) and response code \(error.responseCode ?? -1)")
                        completion(.failure(data: error.responseCode))
                }
            }
    }
    
    struct RequestBody: Codable {
        let amount: Double
        let type: UserModel.BalanceHistory.MovementType
    }
    
}
