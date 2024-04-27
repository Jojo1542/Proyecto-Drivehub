//
//  AdminMainView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 24/4/24.
//

import SwiftUI

struct AdminMainView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel;
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("¡Bienvenido \(authViewModel.currentUser?.firstName ?? "Usuario") \(authViewModel.currentUser?.lastName ?? "")!")
                .fontWeight(.bold)
            
            Text("Tu email es: \(authViewModel.currentUser?.email ?? "Email") y tu id es \(authViewModel.currentUser?.id ?? 0)")
            
            Text("Tu DNI es \(authViewModel.currentUser?.dni ?? "DNI") y tu fecha de nacimiento \(authViewModel.currentUser?.birthDate?.formatted() ?? "FECHA")")
            
            List {
                ForEach(authViewModel.currentUser!.roles, id: \.self) { role in
                    Text(role.rawValue);
                }
            }
        }
    }
}

#Preview {
    AdminMainView()
        .environmentObject(PreviewHelper.authModelAdmin)
}
