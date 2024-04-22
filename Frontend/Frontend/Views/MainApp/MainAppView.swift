//
//  MainAppView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 12/4/24.
//

import SwiftUI

struct MainAppView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel;
    
    @ViewBuilder
    var body: some View {
        VStack {
            HStack {
                Text("")
                
                Spacer()
                
                Button(action: {
                    authViewModel.logout()
                }, label: {
                    Image(systemName: "power")
                })
            }
            .padding()
            
            TabView {
                HomeView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Inicio")
                    }
                
                Text("Mis Favoritos")
                    .tabItem {
                        Image(systemName: "star")
                        Text("Favoritos")
                    }
                
                Text("Mi Perfil")
                    .tabItem {
                        Image(systemName: "person")
                        Text("Perfil")
                    }
            }
        }
    }
}

#Preview {
    MainAppView()
}
