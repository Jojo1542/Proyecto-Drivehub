//
//  CreateVehicleRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 21/5/24.
//

import Foundation
import Alamofire

class CreateVehicleRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/vehicles";
    
    static func createVehicle(sessionToken: String, requestBody: RequestBody, completion: @escaping (Callback<RentCarModel, ErrorType>) -> Void) {
        
        AF.request(url, method: .post, parameters: requestBody, encoder: JSONParameterEncoder(encoder: jsonEncoder), headers: [.authorization(bearerToken: sessionToken)])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .cURLDescription { description in
                print("Create Vehicle request: \(description)")
            }.responseDecodable(of: RentCarModel.self, decoder: jsonDecoder) { response in
                switch response.result {
                    case .success(let result):
                        completion(.success(data: result))
                    case let .failure(error):
                        print("Create Vehicle request failed with error \(error) and response code \(error.responseCode ?? -1)")
                        let problem = decodeProblemDetailsFromResponse(request: response);
                        completion(.failure(data: ErrorType(rawValue: problem.type) ?? .UNKNOWN))
                }
            }
    }
    
    struct RequestBody: Codable {
        let plate: String
        let numBastidor: String
        let brand: String
        let model: String
        let color: String
        let fechaMatriculacion: Date
        let imageUrl: String?
        let precioHora: Double
    }
    
    enum ErrorType: String, CaseIterable, Codable, Hashable {
        case PLATE_ALREADY_EXISTS = "PLATE_ALREADY_EXISTS"
        case BASTIDOR_ALREADY_EXISTS = "BASTIDOR_ALREADY_EXISTS"
        case UNKNOWN = "UNKNOWN"
    }
}
