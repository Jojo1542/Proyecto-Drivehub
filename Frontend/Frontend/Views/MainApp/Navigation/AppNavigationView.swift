//
//  AppNavigationView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 24/4/24.
//

import SwiftUI

struct AppNavigationView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel;
    @EnvironmentObject var appViewModel: AppViewModel;
    
    var body: some View {
        TabView {
            // Comprobación por si las moscas
            TripsMainView()
                .environmentObject(TripsViewModel(appModel: appViewModel))
                .tabItem {
                    Image(systemName: "figure.wave")
                    Text("Trayectos")
                }
            
            RentMainView()
                .environmentObject(RentViewModel(appViewModel: appViewModel))
                .tabItem {
                    Image(systemName: "car.2.fill")
                    Text("Alquilar")
                }
            
            ShipmentsMainView()
                .environmentObject(ShipmentViewModel(appViewModel: appViewModel))
                .tabItem {
                    Image(systemName: "truck.box.badge.clock.fill")
                    Text("Envios")
                }
            // Si el usuario tiene el rol de Administrador, se le muestra la ruta de administración
            if (authViewModel.currentUser!.roles.contains(UserModel.Role.ADMIN)) {
                AdminMainView()
                    .tabItem {
                        Image(systemName: "server.rack")
                        Text("Administración")
                    }
            }
            
            // Si el usuario es conductor de Flota o Chofer, se le muestra la pestaña de conductor, dentro de esta, ya dependiendo de su rol se le muestra de una forma u otra la pantalla de administrador
            if (authViewModel.currentUser!.roles.contains(UserModel.Role.FLEET) || authViewModel.currentUser!.roles.contains(UserModel.Role.CHAUFFEUR)) {
                DriverMainView()
                    .environmentObject(DriverViewModel(appModel: appViewModel))
                    .tabItem {
                        Image(systemName: "car.side")
                        Text("Conductor")
                    }
            }
        }
        .background(.ultraThinMaterial)
    }
}
