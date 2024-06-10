//
//  UserLocationModel.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 22/5/24.
//

import Foundation

struct UserLocationModel: Hashable, Decodable {
    
    var latitude: Double
    var longitude: Double
    var updateTime: Date
    
}
