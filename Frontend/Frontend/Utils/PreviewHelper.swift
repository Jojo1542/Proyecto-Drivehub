//
//  PreviewHelper.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 25/4/24.
//

import Foundation

class PreviewHelper {
    
    static var authModelUser: AuthViewModel {
        let viewModel = AuthViewModel()
        
        viewModel.sessionToken = "TEST.TEST.TEST";
        viewModel.currentUser = UserModel(
            id: 1,
            email: "test@drivehub.com",
            firstName: "Nombre",
            lastName: "Apellidos",
            dni: "99999999R",
            birthDate: Date(),
            saldo: 9.99,
            phone: "+34-666666666",
            roles: [UserModel.Role.USER]
        );
        
        return viewModel
    }
    
    static var authModelUserNotConfirmedDNI: AuthViewModel {
        let viewModel = AuthViewModel()
        
        viewModel.sessionToken = "TEST.TEST.TEST";
        viewModel.currentUser = UserModel(
            id: 1,
            email: "test@drivehub.com",
            firstName: "Nombre",
            lastName: "Apellidos",
            saldo: 9.99,
            phone: "+34-666666666",
            roles: [UserModel.Role.USER]
        );
        
        return viewModel
    }
    
    static var authModelAdmin: AuthViewModel {
        let viewModel = AuthViewModel()
        
        viewModel.sessionToken = "TEST.TEST.TEST";
        viewModel.currentUser = UserModel(
            id: 1,
            email: "test@drivehub.com",
            firstName: "Nombre",
            lastName: "Apellidos",
            dni: "99999999R",
            birthDate: Date(),
            saldo: 9.99,
            phone: "+34-666666666",
            roles: [UserModel.Role.USER, UserModel.Role.ADMIN]
        );
        
        return viewModel
    }
    
    static var authModelFleetDriver: AuthViewModel {
        let viewModel = AuthViewModel()
        
        viewModel.sessionToken = "TEST.TEST.TEST";
        viewModel.currentUser = UserModel(
            id: 1,
            email: "test@drivehub.com",
            firstName: "Nombre",
            lastName: "Apellidos",
            dni: "99999999R",
            birthDate: Date(),
            saldo: 9.99,
            phone: "+34-666666666",
            roles: [UserModel.Role.USER, UserModel.Role.FLEET]
        );
        
        return viewModel
    }
    
    static var authModelFleetChaoffeur: AuthViewModel {
        let viewModel = AuthViewModel()
        
        viewModel.sessionToken = "TEST.TEST.TEST";
        viewModel.currentUser = UserModel(
            id: 1,
            email: "test@drivehub.com",
            firstName: "Nombre",
            lastName: "Apellidos",
            dni: "99999999R",
            birthDate: Date(),
            saldo: 9.99,
            phone: "+34-666666666",
            roles: [UserModel.Role.USER, UserModel.Role.CHAUFFEUR]
        );
        
        return viewModel
    }
    
    static var pendingTrip: TripModel {
        return TripModel(
            id: 1,
            status: TripModel.Status.PENDING,
            date: "25/04/2024",
            startTime: "12:00",
            endTime: nil,
            origin: "37.373469;-5.930973", // Coordenadas origen
            destination: "37.375939;-5.967745", // Coordenadas destino
            price: 9.99,
            distance: 10.0,
            sendPackage: false,
            driver: nil,
            passenger: authModelUser.currentUser!
        )
    }
    
    static var finishedTrip: TripModel {
        return TripModel(
            id: 2,
            status: TripModel.Status.FINISHED,
            date: "25/04/2024",
            startTime: "12:00",
            endTime: "12:30",
            origin: "37.373469;-5.930973", // Coordenadas origen
            destination: "37.375939;-5.967745", // Coordenadas destino
            price: 9.99,
            distance: 10.0,
            sendPackage: false,
            driver: authModelFleetDriver.currentUser!,
            passenger: authModelUser.currentUser!
        )
    }
    
    static var acceptedTrip: TripModel {
        return TripModel(
            id: 3,
            status: TripModel.Status.ACCEPTED,
            date: "25/04/2024",
            startTime: "12:00",
            endTime: nil,
            origin: "37.373469;-5.930973", // Coordenadas origen
            destination: "37.375939;-5.967745", // Coordenadas destino
            price: 9.99,
            distance: 10.0,
            sendPackage: false,
            driver: authModelFleetDriver.currentUser!,
            passenger: authModelUser.currentUser!
        )
    }
    
}
