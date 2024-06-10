//
//  ActiveTripView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 23/5/24.
//

import SwiftUI

struct ActiveTripView: View {
    
    @EnvironmentObject var viewModel: TripsViewModel;
    
    var body: some View {
        if (viewModel.activeTripStatus == .PENDING) {
            SearchingDriverView()
        } else {
            // Se comprueba que el viaje activo no sea nulo por si las moscas
            if viewModel.activeTrip != nil {
                AcceptedTripView(trip: viewModel.activeTrip!)
            } else {
                ProgressView()
            }
        }
    }
}

#Preview {
    ActiveTripView()
}
