//
//  AcceptedTripView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 28/5/24.
//

import SwiftUI
import CoreLocation
import MapKit

struct AcceptedTripView: View {
    
    var trip: TripModel;
    
    @EnvironmentObject var viewModel: TripsViewModel;
    
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    @State var cameraPosition: MapCameraPosition = .userLocation(followsHeading: false, fallback: .automatic);
    @State var route: MKRoute? = nil;
    
    @State var estimatedTimeToArrive: TimeInterval = 0;
    @State var showingRouteToSource: Bool = true;
    
    var body: some View {
        Map(position: $cameraPosition) {
            UserAnnotation()
            
            // Mostrar la ubicación del conductor en el mapa
            if (viewModel.driverLocation != nil) {
                Annotation("Conductor", coordinate: viewModel.driverLocation!) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.background)
                        
                        RoundedRectangle(cornerRadius: 5)
                            .strokeBorder(.background, lineWidth: 1)
                            .padding(2)
                        
                        Image(systemName: "car.fill")
                            .padding(5)
                    }
                }
            }
            
            // Mostrar la rota calculada en el mapa
            if (route != nil) {
                MapPolyline(route!.polyline)
                    .stroke(Color.accentColor, lineWidth: 3)
            }
            
            Marker("Destino", coordinate: trip.destinationPoint)
        }.onAppear() {
            recalculateRoute()
        }.onDisappear() {
            timer.upstream.connect().cancel() // Cancelar el timer
        }
        .onReceive(timer) { _ in
            recalculateRoute()
        }.safeAreaInset(edge: .bottom) {
            VStack(spacing: 15) {
                VStack {
                    // Estimación de llegada
                    VStack(spacing: 10) {
                        HStack {
                            Text("Tiempo estimado de llegada")
                                .font(.headline)
                            
                            Spacer()
                            
                            Text(formatTime(time: estimatedTimeToArrive))
                                .font(.headline)
                        }
                        
                        Button(action: {
                            showingRouteToSource.toggle()
                            recalculateRoute()
                        }) {
                            HStack {
                                Image(systemName: showingRouteToSource ? "arrow.right.circle.fill" : "arrow.left.circle.fill")
                                Text(showingRouteToSource ? "Ver ruta al destino" : "Ver ruta de recogida")
                            }
                            .foregroundColor(.white)
                            .padding(10)
                            .frame(maxWidth: .infinity)
                            .background(Color.accentColor)
                            .cornerRadius(10)
                        }
                    }
                    
                    Divider()
                    
                    // Información del conductor
                    VStack(spacing: 10) {
                        Text("Información del conductor")
                            .font(.title3)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(trip.driver?.fullName ?? "")
                                    .font(.headline)
                                
                                Text("\(trip.driver?.calculateYears() ?? 0) años")
                                    .font(.subheadline)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Divider()
                                .frame(height: 60)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(trip.vehicleModel ?? "")
                                    .font(.headline)
                                
                                Text(trip.vehiclePlate ?? "")
                                    .font(.subheadline)
                                
                                Text(trip.vehicleColor ?? "")
                                    .font(.subheadline)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    
                    
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(15)
            .shadow(radius: 10)
            .frame(maxWidth: .infinity)
        }
    }
    
    func recalculateRoute() {
        let source = (showingRouteToSource ? viewModel.driverLocation : trip.sourcePoint) ?? CLLocationCoordinate2D(latitude: 0, longitude: 0);
        let destination = showingRouteToSource ? trip.sourcePoint : trip.destinationPoint;
        
        calculateRoute(sourceCoordinate: source, destinationCoordinate: destination) { route in
            self.route = route;
            self.estimatedTimeToArrive = route?.expectedTravelTime ?? 0;
        }
    }
    
    func formatTime(time: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute, .second]
        
        return formatter.string(from: time) ?? "";
    }
}
