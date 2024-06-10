//
//  TripModel.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 30/4/24.
//

import Foundation
import CoreLocation
import SwiftUI

struct TripModel: Hashable, Decodable, Identifiable {
    
    var id: Int
    
    var status: Status
    enum Status: String, CaseIterable, Codable, Hashable {
        case PENDING = "PENDING"
        case ACCEPTED = "ACCEPTED"
        case CANCELLED = "CANCELLED"
        case FINISHED = "FINISHED"
        case CANCELLED_DUE_TO_NO_DRIVER = "CANCELLED_DUE_TO_NO_DRIVER"
        
        // User friendly name
        var userFriendlyName: String {
            switch self {
            case .PENDING:
                return "Pendiente"
            case .ACCEPTED:
                return "En progreso"
            case .CANCELLED:
                return "Cancelado"
            case .CANCELLED_DUE_TO_NO_DRIVER:
                return "Cancelado"
            case .FINISHED:
                return "Finalizado"
            }
        }
        
        var color: Color {
            switch self {
            case .PENDING:
                return Color.yellow
            case .ACCEPTED:
                return Color.green
            case .CANCELLED:
                return Color.red
            case .CANCELLED_DUE_TO_NO_DRIVER:
                return Color.red
            case .FINISHED:
                return Color.primary
            }
        }
    }
    
    var date: Date
    var startTime: Date
    var endTime: Date?
    var origin: String
    var destination: String
    var price: Double?
    var distance: Double?
    var sendPackage: Bool
    var driver: DriverInfo?
    var passenger: UserModel
    
    var vehicleModel: String?
    var vehiclePlate: String?
    var vehicleColor: String?
    
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
            let interval = endTime!.timeIntervalSince(startTime)
            let hours = Int(interval) / 3600
            let minutes = Int(interval) / 60 % 60
            
            return String(format: "%02d:%02d", hours, minutes)
        }
    }
    
    var sourcePoint: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: originLat, longitude: originLon)
    }
    
    var destinationPoint: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: destLat, longitude: destLon)
    }
    
    struct DriverInfo: Hashable, Decodable, Identifiable {
        var id: Int
        var firstName: String
        var lastName: String
        var dni: String
        var birthDate: Date
        
        func calculateYears() -> Int {
            return Calendar.current.dateComponents([.year], from: birthDate, to: Date()).year!
        }
        
        var fullName: String {
            return "\(firstName) \(lastName)"
        }
    }
}
