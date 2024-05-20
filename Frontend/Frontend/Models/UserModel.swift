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
    struct AdminData: Hashable, Decodable, Encodable {
        var avaiableTime: String
        var generalPermissions: [AdminPermission]
        var fleetPermissions: [Int64]
        
        enum AdminPermission: String, CaseIterable, Codable, Hashable {
            case SUPER_ADMIN = "SUPER_ADMIN"
            case GET_ALL_USERS = "GET_ALL_USERS"
            case SEE_USER_DETAILS = "SEE_USER_DETAILS"
            case UPDATE_USER = "UPDATE_USER"
            case DELETE_USER = "DELETE_USER"
            case CREATE_SHIPMENT = "CREATE_SHIPMENT"
            case UPDATE_SHIPMENT = "UPDATE_SHIPMENT"
            case DELETE_SHIPMENT = "DELETE_SHIPMENT"
            case LIST_ALL_RENTS = "LIST_ALL_RENTS"
            case LIST_ALL_VEHICLES = "LIST_ALL_VEHICLES"
            case GET_VEHICLE = "GET_VEHICLE"
            case CREATE_VEHICLE = "CREATE_VEHICLE"
            case UPDATE_VEHICLE = "UPDATE_VEHICLE"
            case DELETE_VEHICLE = "DELETE_VEHICLE"
            case CREATE_FLEET = "CREATE_FLEET"
            case DELETE_FLEET = "DELETE_FLEET"
            case CREATE_GENERAL_CONTRACT = "CREATE_GENERAL_CONTRACT"
            case GET_GENERAL_CONTRACT = "GET_GENERAL_CONTRACT"
            case UPDATE_GENERAL_CONTRACT = "UPDATE_GENERAL_CONTRACT"
            case DELETE_GENERAL_CONTRACT = "DELETE_GENERAL_CONTRACT"
            case LIST_RENTS_BY_USER = "LIST_RENTS_BY_USER"
        }
    }
    
    var driverData: DriverData?
    struct DriverData : Hashable, Decodable {
        var avaiableTime: String;
        var maxTonnage: Double;
        var fleet: Int64; // Fleet
    }
    
    var driverLicenses: [DriverLicense]
    struct DriverLicense: Hashable, Decodable, Encodable {
        var licenseNumber: String;
        
        var type: DriverLicenseType;
        enum DriverLicenseType: String, CaseIterable, Codable, Hashable {
            case A1 = "A1"
            case A2 = "A2"
            case A = "A"
            case B = "B"
            case C1 = "C1"
            case C = "C"
            case BE = "BE"
            case CE = "CE"
        }
        
        var expirationDate: Date;
        var issueDate: Date;
    }
    
    var balanceHistory: [BalanceHistory]?;
    struct BalanceHistory: Hashable, Decodable {
        var id: Int;
        var type: MovementType;
        
        enum MovementType: String, CaseIterable, Codable, Hashable {
            case DEPOSIT = "DEPOSIT"
            case WITHDRAW = "WITHDRAW"
        }
        
        var amount: Double;
        var date: Date;
    }
    
    var balanceHistoryList: [BalanceHistory] {
        return balanceHistory ?? [];
    }
}
