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
    var showUser: Bool = false;
    
    var body: some View {
        List {
            Section {
                MapIndicationsView(
                    estimatedTime: $estimatedTime,
                    estimatedDistance: $estimatedDistance,
                    sourceCoordinate: CLLocationCoordinate2D(latitude: trip.originLat, longitude: trip.originLon),
                    destinationCoordinate: CLLocationCoordinate2D(latitude: trip.destLat, longitude: trip.destLon)
                )
                .frame(height: 200)
            }
            .listRowInsets(EdgeInsets())
            
            Section {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Salida")
                            .font(.headline)
                        Text(originAddress)
                            .font(.subheadline)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "arrow.right")
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("Destino")
                            .font(.headline)
                        Text(destinationAddress)
                            .font(.subheadline)
                    }
                }
            }
            
            Section(header: ListSectionHeader(title: "Información del trayecto", icon: "info.circle")) {
                HStack {
                    Text("Estado")
                        .font(.headline)
                    Spacer()
                    Text(trip.status.userFriendlyName)
                        .font(.subheadline)
                        .foregroundColor(trip.status.color)
                }
                
                HStack {
                    Text("Distancia")
                        .font(.headline)
                    Spacer()
                    Text("\(estimatedDistance?.formattedKilometers() ?? "No disponible")")
                        .font(.subheadline)
                }
                
                HStack {
                    Text("Duración")
                        .font(.headline)
                    Spacer()
                    Text("\(formatTime(time: estimatedTime ?? 0))")
                        .font(.subheadline)
                }
                
                // Precio
                HStack {
                    Text("Precio")
                        .font(.headline)
                    Spacer()
                    Text("\(trip.priceString)")
                        .font(.subheadline)
                }
                
                // Fecha
                HStack {
                    Text("Fecha y hora")
                        .font(.headline)
                    Spacer()
                    Text("\(trip.date.formatted())")
                        .font(.subheadline)
                }
            }
            
            Section(header: ListSectionHeader(title: "Conductor", icon: "car")) {
                if let driver = trip.driver {
                    TripDriverCard(driver: driver)
                } else {
                    Text("Conductor no asignado")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            if (trip.vehicleModel != nil && trip.vehiclePlate != nil && trip.vehicleColor != nil) {
                Section(header: ListSectionHeader(title: "Vehiculo", icon: "car.top.door.front.left.and.front.right.open.fill")) {
                    HStack {
                        Image(systemName: "car.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding(5)
                            .background(Color.accentColor)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                        
                        VStack(alignment: .leading) {
                            Text(trip.vehicleModel!)
                                .font(.title)
                                .bold()
                            
                            Text(trip.vehiclePlate!)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            Text(trip.vehicleColor!)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            
            // Booleano para poder reutilizar la vista en diferentes contextos
            if (showUser) {
                Section(header: ListSectionHeader(title: "Usuario", icon: "person")) {
                    UserRow(user: trip.passenger)
                }
            }
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
    
    func formatTime(time: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute, .second]
        
        return formatter.string(from: time) ?? "";
    }
}

#Preview {
    TripDetailsView(trip: PreviewHelper.finishedTrip)
}
