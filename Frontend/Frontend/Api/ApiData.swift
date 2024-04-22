//
//  ApiData.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 12/4/24.
//

import Foundation

@Observable
class ApiData {
    var backendApi: BackendApi = BackendApi(transport: UrlSessionTransport())
}
