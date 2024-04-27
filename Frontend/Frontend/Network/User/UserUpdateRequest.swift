//
//  UserUpdateRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 26/4/24.
//

import Foundation
import Alamofire

class UserUpdateRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/user/update/main";
    
    static func updateUser(sessionToken: String, body: RequestBody, completion: @escaping (Callback<Void, ErrorType>) -> Void) {
        AF.request(url, method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: [.authorization(bearerToken: sessionToken)])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .cURLDescription { description in
                print("Update user request: \(description)")
            }.responseDecodable(of: CommonResponse.self) { response in
                switch response.result {
                    case .success(_):
                        completion(.success())
                    case let .failure(error):
                        if (response.data != nil) {
                            do {
                                // Obtener el tipo de error de la respuesta
                                let errorResponse = try JSONDecoder().decode(CommonResponse.self, from: response.data!);
                                let updateErrorRaw = errorResponse.errorMessage!.components(separatedBy: " - ").last;
                                let errorParsed = ErrorType(rawValue: updateErrorRaw!);
                            
                                completion(.failure(data: errorParsed))
                            } catch {
                                debugPrint("Failed to update user, it ended with error \(error)")
                                completion(.failure(data: ErrorType.UNKNOWN))
                            }
                        } else {
                            debugPrint("Failed to update user, it ended with error \(error) and response data is nil")
                            completion(.failure(data: ErrorType.UNKNOWN))
                        }
                }
            }
    }
    
    enum ErrorType: String, CaseIterable, Codable, Hashable {
        case CANNOT_CHANGE_DNI = "CANNOT_CHANGE_DNI"
        case EMAIL_ALREADY_IN_USE = "EMAIL_ALREADY_IN_USE"
        case DNI_ALREADY_IN_USE = "DNI_ALREADY_IN_USE"
        case UNKNOWN = "UNKNOWN"
    }
    
    struct RequestBody: Encodable {
        var firstName: String?
        var lastName: String?
        var phone: String?
        var email: String?
        var password: String?
        var dni: String?
        var birthDate: Date?
    }
    
}
