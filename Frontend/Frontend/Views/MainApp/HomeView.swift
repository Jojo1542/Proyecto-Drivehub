//
//  HomeView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 16/4/24.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel;
    
    var body: some View {
        VStack {
            Text("¡Bienvenido \(authViewModel.currentUser?.firstName ?? "Usuario") \(authViewModel.currentUser?.lastName ?? "")!")
                .fontWeight(.bold)
            
            Text("Tu email es: \(authViewModel.currentUser?.email ?? "Email") y tu id es \(authViewModel.currentUser?.id ?? 0)")
        }
    }
}

#Preview {
    HomeView()
}
