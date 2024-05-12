//
//  TripModel.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 30/4/24.
//

import Foundation

struct TripModel: Hashable, Decodable, Identifiable {
    
    var id: Int
    
    var status: Status
    enum Status: String, CaseIterable, Codable, Hashable {
        case PENDING = "PENDING"
        case ACCEPTED = "ACCEPTED"
        case REJECTED = "REJECTED"
        case CANCELLED = "CANCELLED"
        case FINISHED = "FINISHED"
    }
    
    var date: String
    var startTime: String
    var endTime: String?
    var origin: String
    var destination: String
    var price: Double?
    var distance: Double?
    var sendPackage: Bool
    var driver: UserModel?
    var passenger: UserModel
    
    /*
     Variables calculadas
     */
    var destCoords: [Double] {
        get {
            return destination.split(separator: ";").map { Double($0)! }
        }
    }
    
    var originCoords: [Double] {
        get {
            return origin.split(separator: ";").map { Double($0)! }
        }
    }
    
    var destLat: Double {
        get {
            return destCoords[0]
        }
    }
    
    var destLon: Double {
        get {
            return destCoords[1]
        }
    }
    
    var originLat: Double {
        get {
            return originCoords[0]
        }
    }
    
    var originLon: Double {
        get {
            return originCoords[1]
        }
    }
    
    var distanceString: String {
        get {
            return String(format: "%.2f km", distance!)
        }
    }
    
    var priceString: String {
        get {
            return String(format: "%.2f €", price!)
        }
    }
    
    var timeElapsed: String {
        get {
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "HH:mm"
            
            let start = dateFormatter.date(from: startTime)!
            let end = dateFormatter.date(from: endTime!)!
            let interval = end.timeIntervalSince(start)
            let hours = Int(interval) / 3600
            let minutes = Int(interval) / 60 % 60
            
            return String(format: "%02d:%02d", hours, minutes)
        }
    }
}
