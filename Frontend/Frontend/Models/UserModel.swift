//
//  UserModel.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 12/4/24.
//

import Foundation

struct UserModel: Hashable, Decodable, Identifiable {
    var id: Int
    var email: String
    var firstName: String
    var lastName: String
    var dni: String?
    var birthDate: Date?
    var saldo: Double
    var phone: String?
    
    var roles: [Role]
    enum Role: String, CaseIterable, Codable, Hashable {
        case USER = "USER"
        case ADMIN = "ADMIN"
        case FLEET = "DRIVER_FLEET"
        case CHAUFFEUR = "DRIVER_CHAUFFEUR"
    }
    
    /*
     Función para calcular los años entre
     */
    func calculateYears() -> Int {
        return Calendar.current.dateComponents([.year], from: birthDate ?? Date(), to: Date()).year!
    }
    
    var adminData: AdminData?
    struct AdminData: Hashable, Decodable {
        var avaiableTime: String
        var generalPermissions: [AdminPermission]
        var fleetPermissions: [Int64]
        
        enum AdminPermission: String, CaseIterable, Codable, Hashable {
            case SUPER_ADMIN = "SUPER_ADMIN"
            case GET_ALL_USERS = "GET_ALL_USERS"
            case SEE_USER_DETAILS = "SEE_USER_DETAILS"
            case UPDATE_USER = "UPDATE_USER"
            case DELETE_USER = "DELETE_USER"
        }
    }
    
}
