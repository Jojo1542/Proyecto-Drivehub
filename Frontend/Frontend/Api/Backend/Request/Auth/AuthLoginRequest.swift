//
//  AuthLoginRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 12/4/24.
//

import Foundation
import RetroSwift

struct AuthLoginRequest {
    @Header("Authorization") var authorization: String = "Basic "
}
