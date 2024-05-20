//
//  NetworkConfiguration.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 25/4/24.
//

import Foundation
import Alamofire

struct NetworkConfiguration {
    static let baseUrl = "http://192.168.1.51:8080"
}

// Configurar Alamofire para que los JSON tengan la fecha en formato unix
var jsonEncoder: JSONEncoder {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .secondsSince1970
    return encoder
}

var jsonDecoder: JSONDecoder {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970
    return decoder
}

// Deprecated Common response created to handle the response of the server
struct CommonResponse: Hashable, Decodable {
    var success: Bool;
    var errorMessage: String?;
}

// Spring Problem Detail structure, to handle errors from the server
struct ProblemDetail: Hashable, Decodable {
    let type: String
    let title: String
    let status: Int
    let detail: String
}
