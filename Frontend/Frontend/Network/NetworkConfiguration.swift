//
//  NetworkConfiguration.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 25/4/24.
//

import Foundation
import Alamofire

struct NetworkConfiguration {
    static let baseUrl = "http://192.168.1.32:8080"
}

struct CommonResponse: Hashable, Decodable {
    var success: Bool;
    var errorMessage: String?;
}
