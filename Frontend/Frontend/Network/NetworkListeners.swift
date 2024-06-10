//
//  NetworkListeners.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 26/5/24.
//

import Foundation

class NetworkListeners {
    
    /*
     case DRIVER_LOCATION = "/trip/stream/location"
     case TRIP_STATUS = "/trip/stream/status"
     case DUTY = "/trip/stream/duty"
     */
    
    private static var driverLocationListener: SseService<UserLocationModel>? = nil
    private static var tripStatusListener: SseService<TripUpdateMessage>? = nil
    private static var dutyListener: SseService<TripModel>? = nil
    
    static func getDriverLocationListener(sessionToken: String) -> SseService<UserLocationModel> {
        if driverLocationListener == nil {
            driverLocationListener = SseService<UserLocationModel>(type: .DRIVER_LOCATION, sessionToken: sessionToken)
        }
        
        // Se remplaza el token de la sesión por si ha cambiado
        driverLocationListener?.sessionToken = sessionToken
        return driverLocationListener!
    }
    
    static func getTripStatusListener(sessionToken: String) -> SseService<TripUpdateMessage> {
        if tripStatusListener == nil {
            tripStatusListener = SseService<TripUpdateMessage>(type: .TRIP_STATUS, sessionToken: sessionToken)
        }
        
        // Se remplaza el token de la sesión por si ha cambiado
        tripStatusListener?.sessionToken = sessionToken
        return tripStatusListener!
    }
    
    static func getDutyListener(sessionToken: String) -> SseService<TripModel> {
        if dutyListener == nil {
            dutyListener = SseService<TripModel>(type: .DUTY, sessionToken: sessionToken)
        }
        
        // Se remplaza el token de la sesión por si ha cambiado
        dutyListener?.sessionToken = sessionToken
        return dutyListener!
    }
    
    struct TripUpdateMessage: Decodable {
        var tripId: Int;
        var status: TripModel.Status;
    }
    
}
