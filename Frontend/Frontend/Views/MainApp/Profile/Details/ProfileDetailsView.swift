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
                NavigationLink {
                    EmptyView()
                } label: {
                    ListSectionTextItem(
                        title: String(localized: "Nombre"),
                        description: "\(authModel.currentUser?.firstName ?? "") \(authModel.currentUser?.lastName ?? "")"
                    )
                }
                
                ListSectionTextItem(
                    title: String(localized: "DNI"),
                    description: authModel.currentUser?.dni ?? ""
                )
                
                NavigationLink {
                    EmptyView()
                } label: {
                    ListSectionTextItem(
                        title: String(localized: "Email"),
                        description: authModel.currentUser?.email ?? ""
                    )
                }
                
                NavigationLink {
                    EmptyView()
                } label: {
                    ListSectionTextItem(
                        title: String(localized: "Teléfono"),
                        description: authModel.currentUser?.phone ?? ""
                    )
                }
                
                NavigationLink {
                    EmptyView()
                } label: {
                    ListSectionTextItem(
                        title: String(localized: "Fecha de nacimiento"),
                        description: authModel.currentUser?.birthDate?.formatted() ?? ""
                    )
                }
            }
            
            // Si tiene más de un rol, se muestra la lista de roles
            Section("Información de desarrollador") {
                if let roles = authModel.currentUser?.roles, roles.count > 1 {
                    NavigationLink {
                        EmptyView()
                    } label: {
                        ListSectionTextItem(
                            title: String(localized: "Roles"),
                            description: roles.map({ $0.rawValue }).joined(separator: ", ")
                        )
                    }
                } else {
                    ListSectionTextItem(
                        title: String(localized: "Rol"),
                        description: authModel.currentUser?.roles.first?.rawValue ?? ""
                    )
                }
            }
            
            
            Section {
                // Texto de como se tratan los datos (Politica de privacidad)
                NavigationLink {
                    PrivacyView()
                } label: {
                    Text(String(localized: "Tratamiento de datos"))
                        .foregroundColor(.accentColor)
                }
                
                // Texto de borrar cuenta
                NavigationLink {
                    EmptyView()
                } label: {
                    Text(String(localized: "Borrar cuenta"))
                        .foregroundColor(.red)
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
