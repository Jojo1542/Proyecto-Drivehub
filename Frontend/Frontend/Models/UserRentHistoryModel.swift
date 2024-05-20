//
//  UserRentHistory.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 15/5/24.
//

import Foundation

struct UserRentHistoryModel: Hashable, Decodable {
    
    var user: UserModel
    var vehicle: RentCarModel
    var startTime: Date
    var endTime: Date?
    var active: Bool
    var finalPrice: Double?
    
}
