//
//  UserUpdateAdminPermissionsRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 30/5/24.
//

import Foundation
import Alamofire

class UserUpdateAdminPermissionsRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/user/update/admin/permissions/{id}";
 
    static func updatePermission(sessionToken: String, userId: Int, body: RequestBody, completion: @escaping (Callback<Void, Int>) -> Void) {
        let url = url.replacingOccurrences(of: "{id}", with: String(userId))
        AF.request(url, method: .post, parameters: body, encoder: JSONParameterEncoder(encoder: jsonEncoder), headers: [.authorization(bearerToken: sessionToken)])
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                    case .success:
                        completion(.success(data: ()))
                    case let .failure(error):
                        print("Update admin permissions request failed with error \(error) and response code \(error.responseCode ?? -1)")
                        completion(.failure(data: error.responseCode))
                }
            }
    }
    
    struct RequestBody: Codable {
        let permissions: [String]
        
        init(permissions: [String]) {
            self.permissions = permissions
        }
        
        init (permissions: [UserModel.AdminData.AdminPermission]) {
            self.permissions = permissions.map { $0.rawValue }
        }
    }
    
}
