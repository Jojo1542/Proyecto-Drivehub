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
    
}
