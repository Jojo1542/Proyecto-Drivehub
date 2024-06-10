//
//  TripListView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 29/4/24.
//

import SwiftUI
import CoreLocation

struct TripListView: View {
    
    @EnvironmentObject var viewModel: AppViewModel;
    
    var body: some View {
        List {
            if (viewModel.tripHistory.count == 0) {
                VStack {
                    Text("No tienes viajes")
                        .font(.title)
                        .padding()
                    Spacer()
                }
            } else {
                ForEach(viewModel.tripHistory) { trip in
                    NavigationLink(destination: TripDetailsView(trip: trip)) {
                        TripRow(trip: trip)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Viajes")
        .refreshable {
            viewModel.fetchTripHistory()
        }.onAppear() {
            viewModel.fetchTripHistory()
        }
    }
}
