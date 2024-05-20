//
//  ShipmentModel.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 15/5/24.
//

import Foundation

struct ShipmentModel: Hashable, Decodable, Identifiable {
    
    var id: Int
    var sourceAddress: String
    var destinationAddress: String
    var shipmentDate: Date
    var deliveryDate: Date
    var hidden: Bool
    var actualStatus: StatusHistory.StatusType
    var statusHistory: [StatusHistory]
    
    struct StatusHistory: Hashable, Decodable {
        let id: Int
        let updateDate: Date
        let status: StatusType
        
        enum StatusType: String, CaseIterable, Codable, Hashable {
            case HIDDEN = "HIDDEN"
            case DELIVERED = "DELIVERED"
            case PENDING_TO_PICK_UP = "PENDING_TO_PICK_UP"
            case IN_TRANSIT = "IN_TRANSIT"
            case PENDING_TO_DELIVER = "PENDING_TO_DELIVER"
            case RETURNED = "RETURNED"
            case CANCELED = "CANCELED"
            case LOST = "LOST"
            case DAMAGED = "DAMAGED"
            case DELAYED = "DELAYED"
            case PENDING_TO_RETURN = "PENDING_TO_RETURN"
        }
        
        let description: String?
    }
    
    var parcels: [Parcel]
    struct Parcel: Hashable, Decodable {
        let id: Int
        let content: String
        let quantity: Int
        let weight: Double
    }
    
    var driver: UserModel?
}
