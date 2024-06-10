//
//  ShipmentModel.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 15/5/24.
//

import Foundation

struct ShipmentModel: Hashable, Decodable, Identifiable, Encodable {
    
    var id: Int
    var sourceAddress: String
    var destinationAddress: String
    var shipmentDate: Date
    var deliveryDate: Date
    var hidden: Bool
    var actualStatus: StatusHistory.StatusType
    var statusHistory: [StatusHistory]
    
    struct StatusHistory: Hashable, Decodable, Identifiable, Encodable {
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
            
            var userFriendlyName: String {
                    switch self {
                    case .HIDDEN:
                        return String(localized: "Oculto")
                    case .DELIVERED:
                        return String(localized: "Entregado")
                    case .PENDING_TO_PICK_UP:
                        return String(localized: "Pendiente de recoger")
                    case .IN_TRANSIT:
                        return String(localized: "En tránsito")
                    case .PENDING_TO_DELIVER:
                        return String(localized: "Pendiente de entregar")
                    case .RETURNED:
                        return String(localized: "Devuelto")
                    case .CANCELED:
                        return String(localized: "Cancelado")
                    case .LOST:
                        return String(localized: "Perdido")
                    case .DAMAGED:
                        return String(localized: "Dañado")
                    case .DELAYED:
                        return String(localized: "Retrasado")
                    case .PENDING_TO_RETURN:
                        return String(localized: "Pendiente de devolver")
                    }
                }
        }
        
        let description: String?
    }
    
    var parcels: [Parcel]
    struct Parcel: Hashable, Decodable, Identifiable, Encodable {
        let id: Int
        let content: String
        let quantity: Int
        let weight: Double
    }
    
    var driver: ShipmentDriver?
    struct ShipmentDriver: Hashable, Decodable, Identifiable, Encodable {
        let id: Int
        let firstName: String
        let lastName: String
        let birthDate: Date
        let dni: String
        let phone: String?
        
        var age: Int {
            let calendar = Calendar.current
            let ageComponents = calendar.dateComponents([.year], from: birthDate, to: Date())
            return ageComponents.year!
        }
        
        var fullName: String {
            return "\(firstName) \(lastName)"
        }
    }
}
