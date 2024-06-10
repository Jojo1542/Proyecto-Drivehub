//
//  ChauffeurAvailableDutyView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 27/5/24.
//

import SwiftUI
import MapKit
import CoreLocation

struct ChauffeurAvailableDutyView: View {
    
    @EnvironmentObject var viewModel: ChauffeurDriverViewModel;
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var cameraPosition: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic);
    @State var offeredRoute: MKRoute? = nil;
    @State var offeredRouteToSource: MKRoute? = nil;
    @State var timeToAccept: Int = 25;
    
    @State var originAddress: String = "";
    @State var destinationAddress: String = "";
    
    var time: String {
        return "\(timeToAccept)";
    }
    
    var body: some View {
        Map(position: $cameraPosition) {
            // Marcador de la posición del conductor
            UserAnnotation()
            
            // Si se está ofreciendo un viaje
            if (viewModel.offeredTrip != nil) {
                if (offeredRoute != nil) {
                    Marker("Salida", systemImage: "", coordinate: viewModel.offeredTrip!.sourcePoint)
                    Marker("Destino", systemImage: "", coordinate: viewModel.offeredTrip!.destinationPoint)
                    
                    MapPolyline(offeredRoute!)
                        .stroke(Color.accentColor, lineWidth: 5)
                }
            }
        }.safeAreaInset(edge: .top) {
            // Avisar sobre que está en servicio y que pueden llegar trayectos
            if (viewModel.offeredTrip == nil) {
                VStack {
                    HStack {
                        Image(systemName: "car.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.primary)
                        
                        Text("En servicio")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding(.leading, 10)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                    .padding()
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            if (viewModel.offeredTrip != nil) {
                VStack(spacing: 16) {
                    Text("Oferta de trayecto")
                        .font(.headline)
                        .padding(.top)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Origen")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text(originAddress)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "arrow.right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.accentColor)
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Destino")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text(destinationAddress)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Distancia hacia salida")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text(offeredRouteToSource?.distance.formattedKilometers() ?? "N/A")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Distancia del trayecto")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text(viewModel.offeredTrip!.distanceString)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }
                    }
                    .padding(.horizontal)
                    
                    Text("Tienes \(time) segundos para aceptar el trayecto")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .padding(.bottom)
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            // Ignorar trayecto
                            withAnimation(.spring) {
                                processAccept()
                            }
                        }, label: {
                            Text("Aceptar")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .cornerRadius(10)
                        })
                        
                        Button(action: {
                            // Ignorar trayecto
                            withAnimation(.spring) {
                                processIgnore()
                            }
                        }, label: {
                            Text("Ignorar")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red)
                                .cornerRadius(10)
                        })
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                .frame(maxWidth: .infinity)
                .background(Color(.systemBackground).opacity(0.9))
                .cornerRadius(15)
                .shadow(radius: 10)
                .padding()
            }
        }.mapControls {
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
        }.onChange(of: viewModel.offeredTrip) { oldValue, newValue in
            if (newValue != nil) {
                // Calcular las dirección de origen y destino
                lookUpCurrentLocation(coordinates: newValue!.sourcePoint) { placemark in
                    originAddress = formattedAddress(from: placemark!);
                }
                
                lookUpCurrentLocation(coordinates: newValue!.destinationPoint) { placemark in
                    destinationAddress = formattedAddress(from: placemark!);
                }
                
                // Calcular la ruta del viaje
                calculateRoute(sourceCoordinate: newValue!.sourcePoint, destinationCoordinate: newValue!.destinationPoint) { route in
                    if (route != nil) {
                        offeredRoute = route;
                    }
                }
                
                // Calcular la ruta hacia el origen
                calculateRoute(sourceCoordinate: viewModel.lastLocation.coordinate, destinationCoordinate: newValue!.sourcePoint) { route in
                    if (route != nil) {
                        offeredRouteToSource = route;
                    }
                }
                
                cameraPosition = .automatic;
                timeToAccept = 25; // Reiniciar el tiempo para acepter
            } else {
                cameraPosition = .userLocation(followsHeading: true, fallback: .automatic);
                
                withAnimation(.spring) {
                    offeredRoute = nil;
                    offeredRouteToSource = nil;
                }
            }
        }.onReceive(timer) { _ in
            if (timeToAccept > 1) {
                timeToAccept -= 1;
            } else if (timeToAccept == 1) {
                viewModel.offeredTrip = nil;
            }
        }.onDisappear() {
            timer.upstream.connect().cancel();
            viewModel.offeredTrip = nil;
            offeredRoute = nil;
            offeredRouteToSource = nil;
        }
    }
    
    func processAccept() {
        // Aceptar trayecto
        viewModel.acceptTrip(tripId: self.viewModel.offeredTrip!.id) { result in
            if result.isFailure() {
                showDialog(title: "Error", description: "No se pudo aceptar el trayecto. Inténtalo de nuevo.");
            }
        }
    }
    
    func processIgnore() {
        // Por motivos de tiempo, para ignorer un trayecto, simplemente, se quita la oferta del viewModel
        viewModel.offeredTrip = nil;
        offeredRoute = nil;
        offeredRouteToSource = nil;
    }
}
