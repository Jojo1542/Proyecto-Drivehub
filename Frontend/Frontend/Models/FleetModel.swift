//
//  FleetModel.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 15/5/24.
//

import Foundation

struct FleetModel: Hashable, Decodable, Identifiable {
    
    var id: Int
    var name: String
    var cif: String
    var vehicleType: VahicleType
    
    enum VahicleType: String, CaseIterable, Codable, Hashable {
        case CAR = "CAR"
        case VAN = "VAN"
        case TRUCK = "TRUCK"
        
        var name: String {
            switch self {
            case .CAR:
                return "Coches"
            case .VAN:
                return "Furgonetas"
            case .TRUCK:
                return "Camiónes"
            }
        }
    }
    
}
