//
//  TripCardView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 30/4/24.
//

import SwiftUI
import CoreLocation

struct TripRow: View {
    
    @State private var estimatedTime: TimeInterval?;
    @State private var estimatedDistance: CLLocationDistance?;
    @State private var destinationAddress: String = "";
    
    var trip: TripModel;
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(destinationAddress)
                        .font(.headline)
                    
                    Text("\(trip.date.formatted(date: .numeric, time: .omitted)) \(trip.startTime.formatted(date: .omitted, time: .shortened)) - \(trip.endTime?.formatted(date: .omitted, time: .shortened) ?? "En progreso")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    // Estado
                    Text(trip.status.userFriendlyName)
                        .font(.subheadline)
                        .foregroundColor(trip.status.color)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    if let price = trip.price {
                        Text("\(price, specifier: "%.2f") €")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                    }
                }
            }
            
            MapIndicationsView(
                estimatedTime: .constant(0),
                estimatedDistance: .constant(0),
                sourceCoordinate: CLLocationCoordinate2D(latitude: trip.originLat, longitude: trip.originLon),
                destinationCoordinate: CLLocationCoordinate2D(latitude: trip.destLat, longitude: trip.destLon)
            )
            .disabled(true)
            .frame(height: 120)
            .cornerRadius(8)
        }
        .padding(.vertical, 8)
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
    NavigationView {
        List {
            NavigationLink(destination: EmptyView()) {
                TripRow(trip: PreviewHelper.acceptedTrip)
            }
            NavigationLink(destination: EmptyView()) {
                TripRow(trip: PreviewHelper.pendingTrip)
            }
            NavigationLink(destination: EmptyView()) {
                TripRow(trip: PreviewHelper.finishedTrip)
            }
        }
    }
}
