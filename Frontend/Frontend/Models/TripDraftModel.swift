//
//  TripDraftModel.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 23/5/24.
//

import Foundation

struct TripDraftModel: Hashable, Decodable, Identifiable {
    
    var id: String
    var origin: String
    var destination: String
    var price: Double
    var distance: Double
    
    var formattedPrice: String {
        get {
            return String(format: "%.2f €", price)
        }
    }
    
    var formattedDistance: String {
        get {
            return String(format: "%.2f km", distance)
        }
    }
    
}
