//
//  ProfileDetailsView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 26/4/24.
//

import SwiftUI

struct ProfileDetailsView: View {
    
    @EnvironmentObject var authModel: AuthViewModel;
    
    var body: some View {
        List {
            Section {
                ListSectionTextItem(
                    title: String(localized: "Nombre"),
                    description: "\(authModel.currentUser?.firstName ?? "") \(authModel.currentUser?.lastName ?? "")"
                )
                
                ListSectionTextItem(
                    title: String(localized: "DNI"),
                    description: authModel.currentUser?.dni ?? ""
                )
                
                ListSectionTextItem(
                    title: String(localized: "Email"),
                    description: authModel.currentUser?.email ?? ""
                )
                
                ListSectionTextItem(
                    title: String(localized: "Teléfono"),
                    description: authModel.currentUser?.phone ?? ""
                )
                
                ListSectionTextItem(
                    title: String(localized: "Fecha de nacimiento"),
                    description: authModel.currentUser?.birthDate?.formatted() ?? ""
                )
            }
            
            Section {
                // Texto de como se tratan los datos (Politica de privacidad)
                NavigationLink {
                    PrivacyView()
                } label: {
                    Text(String(localized: "Tratamiento de datos"))
                        .foregroundColor(.accentColor)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Información personal")
    }
}

#Preview("Usuario") {
    ProfileDetailsView()
        .environmentObject(PreviewHelper.authModelUser)
}
