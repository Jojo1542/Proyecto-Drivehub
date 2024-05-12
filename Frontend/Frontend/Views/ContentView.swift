//
//  ContentView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 12/4/24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel;
    @State private var appViewModel: AppViewModel?;
    @State private var isLoggedIn = false;
    
    var body: some View {
        Group {
            if (authViewModel.currentUser != nil && authViewModel.sessionToken != nil) {
                MainAppView()
                    .environmentObject(appViewModel!)
            } else {
                LoginView()
            }
        }.onAppear {
            // Antes de mostrar lo de arriba, se comprueba si se ha creado el viewModel principal y si no se ha creado, se crea en base de la authenticación
            if (appViewModel == nil) {
                appViewModel = AppViewModel(authViewModel: authViewModel);
            }
        }
        //TripListView()
    }
}

#Preview("NotLogged") {
    ContentView()
        .environmentObject(AuthViewModel())
}

#Preview("No Confirmado") {
    ContentView()
        .environmentObject(PreviewHelper.authModelUserNotConfirmedDNI)
}

#Preview("Usuario") {
    ContentView()
        .environmentObject(PreviewHelper.authModelUser)
}

#Preview("Admin") {
    ContentView()
        .environmentObject(PreviewHelper.authModelAdmin)
}

#Preview("Chofer") {
    ContentView()
        .environmentObject(PreviewHelper.authModelFleetChaoffeur)
}

#Preview("Flota") {
    ContentView()
        .environmentObject(PreviewHelper.authModelFleetDriver)
}
