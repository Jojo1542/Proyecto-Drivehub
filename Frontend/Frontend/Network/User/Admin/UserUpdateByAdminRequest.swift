//
//  UserUpdateByAdminRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 30/5/24.
//

import Foundation
import Alamofire

class UserUpdateByAdminRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/user/update/{id}";
 
    static func updateUser(sessionToken: String, userId: Int, body: RequestBody, completion: @escaping (Callback<Void, Int>) -> Void) {
        let url = url.replacingOccurrences(of: "{id}", with: String(userId))
        AF.request(url, method: .post, parameters: body, encoder: JSONParameterEncoder(encoder: jsonEncoder), headers: [.authorization(bearerToken: sessionToken)])
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                    case .success:
                        completion(.success(data: ()))
                    case let .failure(error):
                        print("Update user request failed with error \(error) and response code \(error.responseCode ?? -1)")
                        completion(.failure(data: error.responseCode))
                }
            }
    }
    
    struct RequestBody: Codable {
        let email: String?
        let firstName: String?
        let lastName: String?
        let password: String?
        let roles: [String]?
        let birthDate: Date?
        let phone: String?
        let DNI: String?
        
        init(email: String? = nil, firstName: String? = nil, lastName: String? = nil, password: String? = nil, roles: [UserModel.Role]? = nil, birthDate: Date? = nil, phone: String? = nil, DNI: String? = nil) {
            self.email = email
            self.firstName = firstName
            self.lastName = lastName
            self.password = password
            self.roles = roles.map { $0.map { $0.rawValue }}
            self.birthDate = birthDate
            self.phone = phone
            self.DNI = DNI
        }
    }
    
}
