//
//  CreateTripDraftRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 23/5/24.
//

import Foundation

import Foundation
import Alamofire

class CreateTripDraftRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/trip/draft";
    
    static func createTripDraft(sessionToken: String, data: RequestBody, completion: @escaping (Callback<TripDraftModel, ErrorType>) -> Void) {
        AF.request(url, method: .post, parameters: data, encoder: JSONParameterEncoder(encoder: jsonEncoder), headers: [.authorization(bearerToken: sessionToken)])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .cURLDescription { description in
                print("Create Trip Draft request: \(description)")
            }.responseDecodable(of: TripDraftModel.self, decoder: jsonDecoder) { response in
                switch response.result {
                    case let .success(data):
                        completion(.success(data: data))
                    case let .failure(error):
                        let errorType = ErrorType(rawValue: error.responseCode?.description ?? "UNKNOWN") ?? .UNKNOWN
                        completion(.failure(data: errorType))
                }
            }
    }
    
    struct RequestBody: Codable {
        let origin: String
        let destination: String
    }
    
    enum ErrorType: String, CaseIterable, Codable, Hashable {
        case INVALID_DISTANCE_BETWEEN = "INVALID_DISTANCE_BETWEEN"
        case UNKNOWN = "UNKNOWN"
    }
}
