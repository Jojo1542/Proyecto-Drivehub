//
//  UserPingRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 12/4/24.
//

import Foundation
import RetroSwift

struct UserPingRequest {
    @Header("Authorization") var authorization: String = "Bearer "
}
