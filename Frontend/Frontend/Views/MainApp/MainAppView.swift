//
//  MainAppView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 12/4/24.
//

import SwiftUI

struct MainAppView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel;
    @State var isProfilePresented: Bool = false;
    
    @ViewBuilder
    var body: some View {
        VStack {
            HStack {
                if (authViewModel.currentUser?.dni != nil) {
                    Button(action: {
                        isProfilePresented = true;
                    }, label: {
                        Image(systemName: "person.crop.circle")
                    })
                } else {
                    Text("")
                }
                
                Spacer()
                
                Button(action: {
                    authViewModel.logout()
                }, label: {
                    Image(systemName: "power")
                })
            }
            .padding()
            
            if (authViewModel.currentUser?.dni == nil) {
                RequieredFieldsView()
                    .transition(.slide)
            } else {
                AppNavigationView()
                    .transition(.slide)
            }
        }.sheet(
            isPresented: $isProfilePresented,
            onDismiss: { isProfilePresented = false },
            content: { ProfileMainView(isPresented: $isProfilePresented) }
        )
    }
}

#Preview("No Confirmado") {
    MainAppView()
        .environmentObject(PreviewHelper.authModelUserNotConfirmedDNI)
}

#Preview("Usuario") {
    MainAppView()
        .environmentObject(PreviewHelper.authModelUser)
}

#Preview("Admin") {
    MainAppView()
        .environmentObject(PreviewHelper.authModelAdmin)
}

#Preview("Chofer") {
    MainAppView()
        .environmentObject(PreviewHelper.authModelFleetChaoffeur)
}

#Preview("Flota") {
    MainAppView()
        .environmentObject(PreviewHelper.authModelFleetDriver)
}
