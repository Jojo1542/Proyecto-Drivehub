//
//  AddDriverLicenseRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 17/5/24.
//

import Foundation
import Alamofire

class AddDriverLicenseRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/user/licenses/add";
    
    public static func addDriverLicense(sessionToken: String, driverLicense: UserModel.DriverLicense, completion: @escaping (Callback<Void, ErrorType>) -> Void) {
        AF.request(url, method: .post, parameters: driverLicense, encoder: JSONParameterEncoder(encoder: jsonEncoder), headers: [.authorization(bearerToken: sessionToken)])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .cURLDescription { description in
                print("Add driver license request: \(description)")
            }.response { response in
                switch response.result {
                    case .success:
                        completion(.success(data: ()))
                    case let .failure(error):
                        print("Add driver license request failed with error \(error) and response code \(error.responseCode ?? -1)")
                        let problem = decodeProblemDetailsFromResponse(request: response);
                        completion(.failure(data: ErrorType(rawValue: problem.type) ?? .UNKNOWN))
                }
            }
    }
    
    enum ErrorType: String, CaseIterable, Codable, Hashable {
        case UNKNOWN = "UNKNOWN"
    }
    
}
