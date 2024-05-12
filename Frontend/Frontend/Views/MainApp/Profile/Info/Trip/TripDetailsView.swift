//
//  TripDetailsView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 30/4/24.
//

import SwiftUI
import CoreLocation

struct TripDetailsView: View {
    
    @State private var estimatedTime: TimeInterval?;
    @State private var estimatedDistance: CLLocationDistance?;
    @State private var destinationAddress: String = "";
    @State private var originAddress: String = "";
    
    var trip: TripModel;
    
    var body: some View {
        VStack(alignment: .leading) {
            MapIndicationsView(
                estimatedTime: $estimatedTime,
                estimatedDistance: $estimatedDistance,
                sourceCoordinate: CLLocationCoordinate2D(latitude: trip.originLat, longitude: trip.originLon),
                destinationCoordinate: CLLocationCoordinate2D(latitude: trip.destLat, longitude: trip.destLon)
            )
            .frame(height: 400)
            
            Text("Viaje desde \(originAddress) a \(destinationAddress)")
                .font(.title)
                .bold()
            
            Spacer()
        }.onAppear() {
            lookUpCurrentLocation(coordinates: CLLocation(latitude: trip.originLat, longitude: trip.originLon)) { (placemark) in
                if let placemark = placemark {
                    originAddress = placemark.name ?? "Dirección desconocida"
                } else {
                    originAddress = "Dirección desconocida"
                }
            }
            
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
    TripDetailsView(trip: PreviewHelper.finishedTrip)
}
