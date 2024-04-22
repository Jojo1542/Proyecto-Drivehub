//
//  BackendApi.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 12/4/24.
//

import Foundation

final class BackendApi: BackendDomain {
    @Post("/auth/register")
    var register: (AuthRegisterRequest) async throws -> Empty
    
    @Post("/auth/login")
    var login: (AuthLoginRequest) async throws -> AuthLoginResponse
}
