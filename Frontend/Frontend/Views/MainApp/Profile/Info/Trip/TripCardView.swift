//
//  TripCardView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 30/4/24.
//

import SwiftUI
import CoreLocation

struct TripCardView: View {
    
    @State private var estimatedTime: TimeInterval?;
    @State private var estimatedDistance: CLLocationDistance?;
    @State private var destinationAddress: String = "";
    
    var trip: TripModel;
    
    var body: some View {
        VStack(alignment: .leading) {
            MapIndicationsView(
                estimatedTime: $estimatedTime,
                estimatedDistance: $estimatedDistance,
                sourceCoordinate: CLLocationCoordinate2D(latitude: trip.originLat, longitude: trip.originLon),
                destinationCoordinate: CLLocationCoordinate2D(latitude: trip.destLat, longitude: trip.destLon)
            )
            .disabled(true)
            .frame(height: 200)
            
            Text("\(destinationAddress)")
                .font(.headline)
            
            Text("\(trip.date) \(trip.startTime) - \(trip.endTime ?? "En progreso")")
                .font(.subheadline)
            
            Text(trip.priceString)
                .font(.caption)
            
            
        }
        .onAppear() {
            lookUpCurrentLocation(coordinates: CLLocation(latitude: trip.destLat, longitude: trip.destLon)) { (placemark) in
                if let placemark = placemark {
                    destinationAddress = placemark.name ?? "Dirección desconocida"
                } else {
                    destinationAddress = "Dirección desconocida"
                }
            }
        }
    }
}

#Preview {
    List {
        TripCardView(trip: PreviewHelper.finishedTrip)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}
