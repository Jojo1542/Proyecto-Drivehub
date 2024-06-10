//
//  ChauffeurDutyView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 27/5/24.
//

import SwiftUI

struct ChauffeurDutyView: View {
    
    @EnvironmentObject var viewModel: ChauffeurDriverViewModel;
    
    var body: some View {
        VStack {
            if (viewModel.activeTrip == nil) {
                ChauffeurAvailableDutyView()
            } else {
                ChauffeurTripDutyView(trip: viewModel.activeTrip!)
            }
        }
        .onAppear() {
            viewModel.startUpdatingLocation();
            viewModel.refreshActiveTrip(); // Refrescar el viaje actual
        }
        .onDisappear() {
            print("Disapapear")
            viewModel.stopUpdatingLocation();
        }
        .navigationBarTitleDisplayMode(.inline)
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
