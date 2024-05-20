//
//  ProfileMainView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 25/4/24.
//

import SwiftUI

struct ProfileMainView: View {
    
    @EnvironmentObject var authModel: AuthViewModel;
    
    @Binding var isPresented: Bool;
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: ProfileDetailsView(), label: {
                        HStack {
                            Image(systemName: "person.crop.circle")
                                .font(.system(size: 80))
                            
                            VStack(alignment: .leading) {
                                let name = authModel.currentUser?.firstName ?? "Nombre";
                                let surname = authModel.currentUser?.lastName ?? "Apellido";
                                
                                Text("\(name) \(surname)")
                                    .font(.title3)
                                
                                Text(authModel.currentUser?.email ?? "Email")
                                    .font(.subheadline)
                                    .foregroundStyle(Color.accentColor)
                            }
                        }
                    })
                }
                
                
                Section(header: ListSectionHeader(title: "Información general", icon: "person.fill")) {
                    NavigationLink(destination: TripListView(trips: [
                        PreviewHelper.finishedTrip,
                        PreviewHelper.pendingTrip,
                        PreviewHelper.acceptedTrip,
                    ]), label: { Label("Mis trayectos", systemImage: "car.fill") });
                    NavigationLink(destination: DocumentsView(), label: { Label("Mis documentos", systemImage: "person.text.rectangle.fill") });
                    NavigationLink(destination: BalanceDetailsView(), label: { Label("Mi saldo", systemImage: "creditcard.fill") });
                }
                
                Section(header: ListSectionHeader(title: "Ajustes", icon: "gear")) {
                    NavigationLink(destination: ChangePasswordView(), label: { Label("Cambiar Contraseña", systemImage: "key.fill") });
                    NavigationLink(destination: EmptyView(), label: { Label("Ajustes de notificaciones", systemImage: "bell.fill") });
                }
                
                Section(header: ListSectionHeader(title: "Sobre la aplicación", icon: "info.circle.fill")) {
                    NavigationLink(destination: AboutAppView(), label: { Label("Acerca de", systemImage: "info.circle.fill") });
                    NavigationLink(destination: PrivacyView(), label: { Label("Política de privacidad", systemImage: "shield.lefthalf.fill") });
                    NavigationLink(destination: TermsView(), label: { Label("Términos y condiciones", systemImage: "doc.text.fill") });
                }
                
                Button(action: {
                    authModel.logout()
                }, label: {
                    HStack {
                        Spacer()
                        
                        Text("Cerrar sesión")
                            .font(.headline)
                            .foregroundStyle(.red)
                        
                        Spacer()
                    }
                })
            }
            .navigationTitle("Perfil")
            .navigationBarItems(trailing: Button("Cerrar") {
                isPresented = false;
            })
        }
    }
}

#Preview("Usuario") {
    ProfileMainView(isPresented: .constant(true))
        .environmentObject(PreviewHelper.authModelUser)
        .environmentObject(AppViewModel(authViewModel: PreviewHelper.authModelUser))
}
