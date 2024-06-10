//
//  UpdateVehicleRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 21/5/24.
//

import Foundation

import Alamofire

class UpdateVehicleRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/vehicles/{id}";
    
    static func updateVehicle(sessionToken: String, requestBody: RentCarModel, completion: @escaping (Callback<RentCarModel, Int>) -> Void) {
        AF.request(url.replacingOccurrences(of: "{id}", with: "\(requestBody.id)"), method: .put, parameters: requestBody, encoder: JSONParameterEncoder(encoder: jsonEncoder), headers: [.authorization(bearerToken: sessionToken)])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .cURLDescription { description in
                print("Update Vehicle request: \(description)")
            }.responseDecodable(of: RentCarModel.self, decoder: jsonDecoder) { response in
                switch response.result {
                    case .success(let result):
                        completion(.success(data: result))
                    case let .failure(error):
                        print("Update Vehicle request failed with error \(error) and response code \(error.responseCode ?? -1)")
                        completion(.failure(data: error.responseCode))
                }
            }
    }
    
}
