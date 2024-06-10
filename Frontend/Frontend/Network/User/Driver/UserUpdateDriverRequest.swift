//
//  UserUpdateDriverRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 26/5/24.
//

import Foundation
import Alamofire

class UserUpdateDriverRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/user/update/driver";
    
    static func updateDriver(sessionToken: String, body: RequestBody, completion: @escaping (Callback<String, Int>) -> Void) {
        AF.request(url, method: .post, parameters: body, encoder: JSONParameterEncoder(encoder: jsonEncoder), headers: [.authorization(bearerToken: sessionToken)])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .cURLDescription { description in
                print("Update Driver request: \(description)")
            }.responseString { response in
                switch response.result {
                    case .success:
                        completion(.success(data: ""))
                    case let .failure(error):
                        print("Update Driver request failed with error \(error) and response code \(error.responseCode ?? -1)")
                        completion(.failure(data: error.responseCode))
                }
            }
    }
    
    struct RequestBody : Codable {
        var avaiableTime: String?;
        var preferedDistance: Double?;
        var vehicleModel: String?;
        var vehiclePlate: String?;
        var vehicleColor: String?;
        var maxTonnage: Double?;
    }
}
