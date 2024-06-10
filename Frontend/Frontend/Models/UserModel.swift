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
    var balance: Double
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
            case LIST_ALL_SHIPMENTS = "LIST_ALL_SHIPMENTS"
            case LIST_ALL_TRIPS = "LIST_ALL_TRIPS"
            
            var userFriendlyName: String {
                switch self {
                case .SUPER_ADMIN:
                    return "Super Administrador"
                case .GET_ALL_USERS:
                    return "Ver todos los usuarios"
                case .SEE_USER_DETAILS:
                    return "Ver detalles de usuario"
                case .UPDATE_USER:
                    return "Actualizar usuario"
                case .DELETE_USER:
                    return "Eliminar usuario"
                case .CREATE_SHIPMENT:
                    return "Crear envío"
                case .UPDATE_SHIPMENT:
                    return "Actualizar envío"
                case .DELETE_SHIPMENT:
                    return "Eliminar envío"
                case .LIST_ALL_RENTS:
                    return "Listar todos los alquileres"
                case .LIST_ALL_VEHICLES:
                    return "Listar todos los vehículos de alquiler"
                case .GET_VEHICLE:
                    return "Ver datos de vehículo de alquiler"
                case .CREATE_VEHICLE:
                    return "Crear vehículo de alquiler"
                case .UPDATE_VEHICLE:
                    return "Actualizar vehículo de alquiler"
                case .DELETE_VEHICLE:
                    return "Eliminar vehículo de alquiler"
                case .CREATE_FLEET:
                    return "Crear flota"
                case .DELETE_FLEET:
                    return "Eliminar flota"
                case .CREATE_GENERAL_CONTRACT:
                    return "Crear contrato general"
                case .GET_GENERAL_CONTRACT:
                    return "Ver contrato general"
                case .UPDATE_GENERAL_CONTRACT:
                    return "Actualizar contrato general"
                case .DELETE_GENERAL_CONTRACT:
                    return "Eliminar contrato general"
                case .LIST_RENTS_BY_USER:
                    return "Listar alquileres por usuario"
                case .LIST_ALL_SHIPMENTS:
                    return "Listar todos los envíos"
                case .LIST_ALL_TRIPS:
                    return "Listar todos los viajes"
                }
            }
            
            enum Category: CaseIterable {
                case ADMIN, USER, SHIPMENT, RENT, FLEET, GENERAL_CONTRACT, TRIP
                
                var userFriendlyName: String {
                    switch self {
                    case .ADMIN:
                        return "Administradores"
                    case .USER:
                        return "Usuarios"
                    case .SHIPMENT:
                        return "Envíos"
                    case .RENT:
                        return "Alquileres"
                    case .FLEET:
                        return "Flotas"
                    case .GENERAL_CONTRACT:
                        return "Contratos generales"
                    case .TRIP:
                        return "Viajes"
                    }
                }
                
                
                var icon: String {
                    switch self {
                    case .ADMIN:
                        return "person.3.fill"
                    case .USER:
                        return "person.fill"
                    case .SHIPMENT:
                        return "shippingbox.fill"
                    case .RENT:
                        return "dollarsign.circle.fill"
                    case .FLEET:
                        return "car.fill"
                    case .GENERAL_CONTRACT:
                        return "doc.text.fill"
                    case .TRIP:
                        return "map.fill"
                    }
                }
                
                var permissions: [AdminPermission] {
                    switch self {
                    case .ADMIN:
                        return [.SUPER_ADMIN]
                    case .USER:
                        return [.GET_ALL_USERS, .SEE_USER_DETAILS, .UPDATE_USER, .DELETE_USER]
                    case .SHIPMENT:
                        return [.CREATE_SHIPMENT, .UPDATE_SHIPMENT, .DELETE_SHIPMENT]
                    case .RENT:
                        return [.LIST_ALL_RENTS, .LIST_RENTS_BY_USER, .LIST_ALL_VEHICLES, .GET_VEHICLE, .CREATE_VEHICLE, .UPDATE_VEHICLE, .DELETE_VEHICLE]
                    case .FLEET:
                        return [.CREATE_FLEET, .DELETE_FLEET]
                    case .GENERAL_CONTRACT:
                        return [.CREATE_GENERAL_CONTRACT, .GET_GENERAL_CONTRACT, .UPDATE_GENERAL_CONTRACT, .DELETE_GENERAL_CONTRACT]
                    case .TRIP:
                        return [.LIST_ALL_TRIPS]
                    }
                }
            }
        }
    }
    
    var driverData: DriverData?
    struct DriverData : Hashable, Decodable {
        var avaiableTime: String;
        
        // Datos que tiene un conductor de flota
        var maxTonnage: Double?; // Fleet
        var fleet: Int64?; // Fleet
        
        // Datos que tiene un choffer
        var preferedDistance: Double?; // Choffer
        var canTakePassengers: Bool?; // Choffer
        var vehicleModel: String?; // Choffer
        var vehiclePlate: String?; // Choffer
        var vehicleColor: String?; // Choffer
        
        var validAsChoffer: Bool {
            return vehicleModel != nil && vehiclePlate != nil && vehicleColor != nil;
        }
        
        var validAsFleet: Bool {
            return maxTonnage != nil && fleet != nil;
        }
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
        return balanceHistory?.sorted(by: { $0.date > $1.date }) ?? [];
    }
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    var isValidated: Bool {
        return dni != nil && phone != nil && birthDate != nil;
    }
}
