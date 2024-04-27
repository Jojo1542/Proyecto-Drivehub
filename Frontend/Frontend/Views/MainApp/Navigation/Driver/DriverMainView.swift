//
//  DriverMainView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 24/4/24.
//

import SwiftUI

struct DriverMainView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel;
    
    var body: some View {
        // Dependiendo de si es Conductor de Flota o Chofer, se le muestra la vista correspondiente
        if (authViewModel.currentUser!.roles.contains(UserModel.Role.FLEET)) {
            FleetDriverMainView()
        } else {
            ChauffeurDriverMainView()
        }
    }
}

#Preview("Chofer") {
    DriverMainView()
        .environmentObject(PreviewHelper.authModelFleetChaoffeur)
}

#Preview("Flota") {
    DriverMainView()
        .environmentObject(PreviewHelper.authModelFleetDriver)
}
