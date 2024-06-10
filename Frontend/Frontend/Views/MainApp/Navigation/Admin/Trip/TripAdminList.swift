//
//  TripAdminList.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 30/5/24.
//

import SwiftUI

struct TripAdminList: View {
    
    @EnvironmentObject var viewModel: AdminTripViewModel;
    
    @State var searchText = "";
    
    var onlyActive: Bool;
    
    private var filteredTrips: [TripModel] {
        return viewModel.trips;
    }
    
    var body: some View {
        List(filteredTrips) { trip in
            NavigationLink(destination: TripDetailsView(trip: trip, showUser: true)) {
                TripRow(trip: trip)
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .navigationTitle(onlyActive ? "Lista de Asignaciones" : "Historial de trayectos")
        .refreshable {
            if (onlyActive) {
                viewModel.fetchActiveTrips();
            } else {
                viewModel.fetchTrips();
            }
        }.onAppear() {
            if (onlyActive) {
                viewModel.fetchActiveTrips();
            } else {
                viewModel.fetchTrips();
            }
        }
    }
}

#Preview {
    TripAdminList(onlyActive: false)
}
