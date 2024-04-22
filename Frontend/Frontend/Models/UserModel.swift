//
//  UserModel.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 12/4/24.
//

import Foundation

struct UserModel: Decodable {
    var id: Int
    var email: String
    var firstName: String
    var lastName: String
}
