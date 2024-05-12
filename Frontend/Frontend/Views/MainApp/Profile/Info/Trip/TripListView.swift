//
//  TripListView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 29/4/24.
//

import SwiftUI
import CoreLocation

struct TripListView: View {
    
    var trips: [TripModel] = []
    
    var body: some View {
        List {
            if (trips.count == 0) {
                VStack {
                    Text("No tienes viajes")
                        .font(.title)
                        .padding()
                    Spacer()
                }
            } else {
                ForEach(trips) { trip in
                    NavigationLink(destination: TripDetailsView(trip: trip)) {
                        TripCardView(trip: trip)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Viajes")
        .refreshable {
            print("Refreshing")
        }
    }
}

#Preview("Sin viajes") {
    TripListView()
}

#Preview("Cpn viajes") {
    NavigationView {
        TripListView(trips: [
            PreviewHelper.finishedTrip,
            PreviewHelper.pendingTrip,
            PreviewHelper.finishedTrip,
        ])
    }
}
