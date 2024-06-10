//
//  DraftSheetView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 24/5/24.
//

import SwiftUI
import CoreLocation

struct DraftSheetView: View {
    
    @Environment(\.colorScheme) var colorScheme;
    @EnvironmentObject var viewModel: TripsViewModel;
    
    var draft: TripDraftModel;
    
    @State private var destinationLocation: CLLocation?;
    @State private var sourceLocation: CLLocation?;
    @State private var sendPackage: Bool = false;
    
    @State private var loading = false;
    @State private var showConfirmationModal = false;
    
    var body: some View {
        VStack(spacing: 20) {
            // Mapa donde muestra el origen y destino
            if (destinationLocation != nil && sourceLocation != nil) {
                MapIndicationsView(
                    estimatedTime: .constant(0),
                    estimatedDistance: .constant(0),
                    sourceCoordinate: CLLocationCoordinate2D(
                        latitude: sourceLocation!.coordinate.latitude,
                        longitude: sourceLocation!.coordinate.longitude
                    ),
                    destinationCoordinate: CLLocationCoordinate2D(
                        latitude: destinationLocation!.coordinate.latitude,
                        longitude: destinationLocation!.coordinate.longitude
                    )
                )
                .frame(height: 200)
                .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/) // Que no se pueda interactuar con el mapa
                .cornerRadius(10)
                .shadow(radius: 5)
            }
            
            // Información de donde sale y a donde va
            HStack {
                VStack {
                    Image(systemName: "location.circle.fill")
                        .foregroundColor(.accentColor)
                    Rectangle()
                        .fill(Color.secondary)
                        .frame(width: 2, height: 55)
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.red)
                }
                VStack(alignment: .leading) {
                    Text("Origen")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text(draft.origin)
                        .font(.title3)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    
                    Divider()
                        .padding(.vertical, 10)
                    
                    Text("Destino")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text(draft.destination)
                        .font(.title3)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                }
                .padding(.leading, 10)
            }
            .padding()
            .background(colorScheme == .dark ? Color.black : Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            
            // Información del tiempo de llegada y distancia
            VStack {
                HStack {
                    Text("Distancia")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(draft.distance, format: .number) km")
                        .font(.title3)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                }
                
                Divider()
                    .padding(.vertical, 10)
                
                HStack {
                    Text("Precio estimado")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(draft.price, format: .number) €")
                        .font(.title3)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                }
                
                Divider()
                    .padding(.vertical, 10)
                // Toggle de si va a enviar un paquete
                
                HStack {
                    Toggle(isOn: $sendPackage, label: {
                        Text("Envia un paquete")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    })
                }
            }
            
            Divider()
                .padding(.vertical, 5)
            
            // Botón para aceptar el viaje
            VStack(alignment: .center) {
                Button(action: {
                    self.showConfirmationModal.toggle()
                }, label: {
                    if (!loading) {
                        Text("Confirmar y Pagar")
                            .frame(maxWidth: .infinity)
                    } else {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                    }
                })
                .disabled(loading)
                .padding()
                .foregroundColor(.white)
                .background(Color.accentColor)
                .cornerRadius(10)
                .alert(isPresented: $showConfirmationModal) {
                    Alert(
                        title: Text("¿Estás seguro de que quieres confirmar el viaje?"),
                        message: Text("Al confirmar el viaje se procederá al pago de \(draft.price, format: .number) €"),
                        primaryButton: .default(Text("Confirmar"), action: {
                            withAnimation(.bouncy) {
                                self.loading = true
                                self.processTripCreation()
                            }
                        }),
                        secondaryButton: .cancel(Text("Cancelar"))
                    )
                }
            }.frame(maxWidth: .infinity)
            
            Spacer()
        }
        .padding()
        .onAppear() {
            lookUpAddress(address: draft.origin) { placemark in
                if let placemark = placemark {
                    sourceLocation = placemark.location
                }
            }
            
            lookUpAddress(address: draft.destination) { placemark in
                if let placemark = placemark {
                    destinationLocation = placemark.location
                }
            }
        }
    }
    
    private func processTripCreation() {
        viewModel.startTrip(draft: draft, sendPackage: sendPackage) { result in
            switch result {
            case .success(_):
                self.loading = false
            case .failure(let error):
                switch error {
                case .INSSUFICIENT_FUNDS:
                    showDialog(title: "Fondos insuficientes", description: "No tienes suficientes fondos para realizar el viaje")
                    break;
                case .ACTIVE_TRIP_EXISTS:
                    showDialog(title: "Viaje activo", description: "Ya tienes un viaje activo, finalizalo antes de crear uno nuevo")
                    break;
                default:
                    showDialog(title: "Error", description: "Ha ocurrido un error al crear el viaje")
                }
            }
            
            self.loading = false
        }
    }
}

#Preview("Sheet") {
    var authModel = PreviewHelper.authModelUser;
    var appModel = AppViewModel(authViewModel: authModel);
    var tripModel = TripsViewModel(appModel: appModel);
    
    return Text("Hola")
        .sheet(isPresented: .constant(true), content: {
            DraftSheetView(draft: TripDraftModel(id: "asd123", origin: "Calle Solidaridad, 50, Sevilla, 41006", destination: "Calle Fernandez de Ribera, 17, Sevilla, 41006", price: 100.0, distance: 6.8))
                .environmentObject(authModel)
                .environmentObject(appModel)
                .environmentObject(tripModel)
        })
}
