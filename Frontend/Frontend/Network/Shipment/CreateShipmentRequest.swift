//
//  CreateShipmentRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 21/5/24.
//

import Foundation
import Alamofire

class CreateShipmentRequest {
    
    private static let url = "\(NetworkConfiguration.baseUrl)/ship/create";
    
    static func createShipment(sessionToken: String, requestBody: RequestBody, completion: @escaping (Callback<ShipmentModel, ErrorType>) -> Void) {
        
        AF.request(url, method: .post, parameters: requestBody, encoder: JSONParameterEncoder(encoder: jsonEncoder), headers: [.authorization(bearerToken: sessionToken)])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .cURLDescription { description in
                print("Create Shipment request: \(description)")
            }.responseDecodable(of: ShipmentModel.self, decoder: jsonDecoder) { response in
                switch response.result {
                    case .success(let result):
                        completion(.success(data: result))
                    case let .failure(error):
                        print("Create Shipment request failed with error \(error) and response code \(error.responseCode ?? -1)")
                        let problem = decodeProblemDetailsFromResponse(request: response);
                        completion(.failure(data: ErrorType(rawValue: problem.type) ?? .UNKNOWN))
                }
            }
    }
    
    struct RequestBody: Codable {
        let sourceAddress: String
        let destinationAddress: String
        let shipmentDate: Date
        let deliveryDate: Date
        let parcels: [Parcel]
        let driverId: Int
        
        struct Parcel: Codable, Identifiable {
            var id: UUID = UUID(); // ID para poder meterlo en el ForEach
            let content: String
            let quantity: Int
            let weight: Double
            
            // Solo permitir que se codifiquen estos campos
            enum CodingKeys: String, CodingKey {
                case content, quantity, weight
            }
        }
    }
    
    enum ErrorType: String, CaseIterable, Codable, Hashable {
        case INVALID_SHIPMENT_DATE = "INVALID_SHIPMENT_DATE"
        case PARCELS_CANNOT_BE_EMPTY = "PARCELS_CANNOT_BE_EMPTY"
        case DRIVER_NOT_FOUND = "DRIVER_NOT_FOUND"
        case UNKNOWN = "UNKNOWN"
    }
    
}
