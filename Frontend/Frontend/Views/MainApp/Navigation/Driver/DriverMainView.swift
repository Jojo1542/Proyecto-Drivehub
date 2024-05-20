//
//  DriverMainView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 24/4/24.
//

import SwiftUI

struct DriverMainView: View {
    
    @EnvironmentObject var driverModel: DriverViewModel;
    
    var body: some View {
        // Dependiendo de si es Conductor de Flota o Chofer, se le muestra la vista correspondiente
        if (driverModel.user.roles.contains(UserModel.Role.FLEET)) {
            FleetDriverMainView()
                .environmentObject(FleetDriverViewModel(driverModel: driverModel))
        } else {
            ChauffeurDriverMainView()
        }
    }
}

#Preview("Chofer") {
    let authModel = PreviewHelper.authModelChaoffeur;
    let appModel = AppViewModel(authViewModel: authModel);
    
    return DriverMainView()
        .environmentObject(DriverViewModel(appModel: appModel))
        .environmentObject(authModel)
        .environmentObject(appModel)
}

#Preview("Flota") {
    let authModel = PreviewHelper.authModelFleetDriver;
    let appModel = AppViewModel(authViewModel: authModel);
    
    return DriverMainView()
        .environmentObject(DriverViewModel(appModel: appModel))
        .environmentObject(authModel)
        .environmentObject(appModel)
}
