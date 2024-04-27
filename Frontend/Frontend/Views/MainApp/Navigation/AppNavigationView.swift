//
//  AppNavigationView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 24/4/24.
//

import SwiftUI

struct AppNavigationView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel;
    
    var body: some View {
        TabView {
            // Comprobación por si las moscas
            HomeView()
                .tabItem {
                    Image(systemName: "figure.wave")
                    Text("Trayectos")
                }
            
            Text("Alquilar")
                .tabItem {
                    Image(systemName: "car.2.fill")
                    Text("Alquilar")
                }
            
            Text("Envios")
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
                    .tabItem {
                        Image(systemName: "car.side")
                        Text("Conductor")
                    }
            }
            
        }
    }
}

#Preview {
    AppNavigationView()
}
