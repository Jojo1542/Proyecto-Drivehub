//
//  GetActualRentRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 17/5/24.
//

import Foundation
import Alamofire

class GetActualRentRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/rent/active";
      
    static func getActualRent(sessionToken: String, completion: @escaping (Callback<UserRentHistoryModel, Int>) -> Void) {
        AF.request(url, headers: [.authorization(bearerToken: sessionToken)])
            // Allow 2xx and 404 response codes
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .cURLDescription { description in
                print("Actual rent request: \(description)")
            }.responseDecodable(of: UserRentHistoryModel.self, decoder: jsonDecoder) { response in
                switch response.result {
                    case .success(let result):
                        completion(.success(data: result))
                    case let .failure(error):
                        completion(.failure(data: error.responseCode))
                }
            }
    }
    
    
}
