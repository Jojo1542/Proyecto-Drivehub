//
//  RemoveDriverLicenseRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 17/5/24.
//

import Foundation
import Alamofire

class RemoveDriverLicenseRequest {
    
    public static let url = "\(NetworkConfiguration.baseUrl)/user/licenses/remove/{id}";
    
    public static func removeDriverLicense(sessionToken: String, driverLicenseId: String, completion: @escaping (Callback<Void, ErrorType>) -> Void) {
        let url = url.replacingOccurrences(of: "{id}", with: driverLicenseId)
        AF.request(url, method: .delete, headers: [.authorization(bearerToken: sessionToken)])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .cURLDescription { description in
                print("Remove driver license request: \(description)")
            }.response { response in
                switch response.result {
                    case .success:
                        completion(.success(data: ()))
                    case let .failure(error):
                        print("Remove driver license request failed with error \(error) and response code \(error.responseCode ?? -1)")
                        let problem = decodeProblemDetailsFromResponse(request: response);
                        completion(.failure(data: ErrorType(rawValue: problem.type) ?? .UNKNOWN))
                }
            }
    }
    
    enum ErrorType: String, CaseIterable, Codable, Hashable {
        case LICENSE_NOT_FOUND = "LICENSE_NOT_FOUND"
        case UNKNOWN = "UNKNOWN"
    }
    
}
