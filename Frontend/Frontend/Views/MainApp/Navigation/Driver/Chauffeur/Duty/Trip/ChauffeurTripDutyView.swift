//
//  ChauffeurTripDutyView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 27/5/24.
//

import SwiftUI
import CoreLocation
import MapKit

struct ChauffeurTripDutyView: View {
    
    var trip: TripModel;
    
    @EnvironmentObject var viewModel: ChauffeurDriverViewModel;
    
    @State var cameraPosition: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic);
    @State var route: MKRoute? = nil;
    
    @State var originLocation: CLPlacemark?;
    @State var destinationLocation: CLPlacemark?;
    
    @State var showingRouteToSource: Bool = false;
    @State var showingMapSelector: Bool = false;
    
    var body: some View {
        Map(position: $cameraPosition) {
            // Marcador de la posición del conductor
            UserAnnotation()
            
            if (originLocation != nil) {
                Marker("Salida", systemImage: "figure.wave", coordinate: originLocation!.location!.coordinate)
            }
            
            if (destinationLocation != nil) {
                Marker("Destino", systemImage: "figure.walk", coordinate: destinationLocation!.location!.coordinate)
            }
            
            if (route != nil) {
                MapPolyline(route!)
                    .stroke(Color.accentColor, lineWidth: 5)
            }
        }.onAppear() {
            // Calcular las dirección de origen y destino
            lookUpCurrentLocation(coordinates: trip.sourcePoint) { placemark in
                originLocation = placemark;
            }
            
            lookUpCurrentLocation(coordinates: trip.destinationPoint) { placemark in
                destinationLocation = placemark
            }
            
            recalculateRoute()
        }.onChange(of: showingRouteToSource) { oldValue, newValue in
            recalculateRoute()
        }.mapControls {
            MapUserLocationButton()
            MapScaleView()
        }.safeAreaInset(edge: .bottom) {
            VStack {
                VStack(spacing: 15) {
                    // Información del viaje, como el nombre del pasajero y DNI
                    VStack(alignment: .leading, spacing: 10) {
                        // Nombre del pasajero
                        Text(trip.passenger.fullName)
                            .font(.title)
                            .bold()
                        
                        HStack {
                            // DNI del pasajero
                            Text("DNI: \(trip.passenger.dni ?? "No disponible")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            // Botón de llamar al pasajero
                            if let phone = trip.passenger.phone {
                                Button(action: {
                                    // Llamar al pasajero
                                }) {
                                    HStack {
                                        Image(systemName: "phone.fill")
                                        Text("Llamar")
                                    }
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.accentColor)
                                    .cornerRadius(10)
                                }
                            }
                        }
                    }
                    
                    Divider()
                    
                    HStack {
                        Button(action: {
                            showingRouteToSource.toggle()
                        }) {
                            HStack {
                                Image(systemName: showingRouteToSource ? "arrow.right.circle.fill" : "arrow.left.circle.fill")
                                Text(showingRouteToSource ? "Ruta al destino" : "Ruta a la salida")
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.accentColor)
                            .cornerRadius(10)
                        }
                        
                        Spacer()
                        
                        // Botón de abrir en maps para iniciar navegación
                        Button(action: {
                            showingMapSelector.toggle()
                        }) {
                            HStack {
                                Image(systemName: "map.fill")
                                Text("Abrir en Maps")
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.accentColor)
                            .cornerRadius(10)
                        }
                    }
                    
                    Divider()
                    
                    // Botones de Cancelar y Finalizar viaje
                    HStack {
                        Button(action: {
                            viewModel.finalizeTrip(tripId: trip.id, cancelled: true) { result in
                                switch result {
                                case .success(_):
                                    showDialog(title: "Trayecto cancelado", description: "El trayecto ha sido cancelado con éxito");
                                    break;
                                case .failure(let error):
                                    showDialog(title: "Error", description: "No es posible cancelar el trayecto. Error: \(error ?? 0)");
                                    break;
                                }
                            }
                        }) {
                            HStack {
                                Image(systemName: "xmark.octagon.fill")
                                Text("Cancelar viaje")
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.finalizeTrip(tripId: trip.id, cancelled: false) { result in
                                switch result {
                                case .success(_):
                                    showDialog(title: "Trayecto finalziado", description: "El trayecto ha sido finalizado con éxito");
                                    break;
                                case .failure(let error):
                                    showDialog(title: "Error", description: "No es posible finalizar el trayecto. Error: \(error ?? 0)");
                                    break;
                                }
                            }
                        }) {
                            HStack {
                                Image(systemName: "checkmark.seal.fill")
                                Text("Finalizar viaje")
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                        }
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(15)
                .shadow(radius: 10)
                .frame(maxWidth: .infinity)
            }
        }.actionSheet(isPresented: $showingMapSelector) {
            ActionSheet(
                title: Text("¿Con que aplicación deseas abrir la ruta?"),
                message: Text("Selecciona una aplicación para iniciar la navegación"),
                buttons: [
                    .default(Text("Apple Maps")) {
                        openAppleMapsNavigation(destinationCoordinate: showingRouteToSource ? trip.sourcePoint : trip.destinationPoint)
                    },
                    .default(Text("Google Maps")) {
                        openGoogleMapsNavigation(destinationCoordinate: showingRouteToSource ? trip.sourcePoint : trip.destinationPoint)
                    },
                    .default(Text("Waze")) {
                        openWazeNavigation(destinationCoordinate: showingRouteToSource ? trip.sourcePoint : trip.destinationPoint)
                    },
                    .cancel()
                ]
            )
        }
    }
    
    func recalculateRoute() {
        let source = showingRouteToSource ? viewModel.lastLocation.coordinate : trip.sourcePoint;
        let destination = showingRouteToSource ? trip.sourcePoint : trip.destinationPoint;
        
        calculateRoute(sourceCoordinate: source, destinationCoordinate: destination) { route in
            self.route = route;
            
            // Actualizar la camara para que se coloque bien
            cameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
        }
    }
    
    func makeCall(phoneNumber: String) {
        //let uri = "tel://\(phoneNumber)" -> Esto llama de verdad, ponerlo solamente cuando termine las pruebas
        let uri = "telprompt://\(phoneNumber)"
        if let url = URL(string: uri), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

}
