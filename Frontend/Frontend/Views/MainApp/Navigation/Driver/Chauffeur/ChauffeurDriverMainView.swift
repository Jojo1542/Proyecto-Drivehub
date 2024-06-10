//
//  ChauffeurDriverMainView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 24/4/24.
//

import SwiftUI

struct ChauffeurDriverMainView: View {
    
    @EnvironmentObject var viewModel: ChauffeurDriverViewModel;
    @EnvironmentObject var authViewModel: AuthViewModel;
    
    var body: some View {
        if (authViewModel.currentUser?.driverData?.validAsChoffer ?? false) {
            NavigationView {
                List {
                    // Acceder a la jornada
                    NavigationLink(destination: ChauffeurDutyView(), label: { Label("Comenzar a conducir", systemImage: "figure.wave") });
                    
                    // Información del vehículo
                    NavigationLink(destination: DriverVehicleDetailsView(), label: { Label("Información del vehículo", systemImage: "car.fill") });
                    
                    // Ajustes personales
                    NavigationLink(destination: DriverPersonalDetailsView(), label: { Label("Ajustes personales", systemImage: "gearshape.fill") });
                }
                .navigationTitle("Choffer")
                .navigationBarTitleDisplayMode(/*@START_MENU_TOKEN@*/.automatic/*@END_MENU_TOKEN@*/)
            }
        } else {
            DriverNoVehicleView()
        }
    }
}

#Preview {
    let authModel = PreviewHelper.authModelChaoffeur;
    let appModel = AppViewModel(authViewModel: authModel);
    let driverModel = DriverViewModel(appModel: appModel);
    
    return ChauffeurDriverMainView()
        .environmentObject(ChauffeurDriverViewModel(driverModel: driverModel))
        .environmentObject(driverModel)
        .environmentObject(authModel)
        .environmentObject(appModel)
}
