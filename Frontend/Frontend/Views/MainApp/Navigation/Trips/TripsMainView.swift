//
//  HomeView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 16/4/24.
//

import SwiftUI

struct TripsMainView: View {
    
    @EnvironmentObject var viewModel: TripsViewModel;
    
    var body: some View {
        Group {
            if (viewModel.activeTrip == nil) {
                TripsSearchView()
            } else {
                ActiveTripView()
            }
        }.onAppear() {
            // Refresca el viaje activo
            viewModel.refreshActiveTrip();
        }
    }
}

#Preview {
    let authModel = PreviewHelper.authModelUser;
    let appViewModel = AppViewModel(authViewModel: authModel);
    
    return TripsMainView()
        .environmentObject(authModel)
        .environmentObject(appViewModel)
        .environmentObject(TripsViewModel(appModel: appViewModel))
    
}
