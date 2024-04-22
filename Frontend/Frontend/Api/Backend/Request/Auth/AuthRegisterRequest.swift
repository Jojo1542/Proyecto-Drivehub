//
//  AuthRegisterRequest.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 12/4/24.
//

import Foundation
import RetroSwift

struct AuthRegisterRequest {
    @Query("email") var email: String = ""
    @Query("password") var password: String = ""
    @Query("firstName") var firstName: String = ""
    @Query("lastName") var lastName: String = ""
}
