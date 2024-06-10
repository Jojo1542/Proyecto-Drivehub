//
//  TripsMenuView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 22/5/24.
//

import SwiftUI
import CoreLocation

struct TripsMenuView: View {
    
    @EnvironmentObject var viewModel: TripsViewModel;
    
    @State var searchText: String = ""
    
    @State var history: [CLPlacemark] = []
    @State var searchResults: [CLPlacemark] = []
    
    @State var isLoading: Bool = false
    
    @State var isShowingTripDetails: Bool = false
    @State var draft: TripDraftModel?
    
    var locations: [CLPlacemark] {
        if searchText.isEmpty {
            return history
        } else {
            return searchResults
        }
    }
    
    var body: some View {
        ZStack {
            // Si esta buscando un destino, mostrar un spinner
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
            }
            
            VStack {
                // TextField introduce destino
                TextField("Introduce tu destino", text: $searchText)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding()
                
                // Lista de posibles destinos
                List(locations.indices, id: \.self) { index in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(locations[index].name ?? "")
                                .font(.headline)
                            Text(locations[index].locality ?? "")
                                .font(.subheadline)
                        }
                        Spacer()
                        Button(action: {
                            withAnimation(.spring) {
                                processTripDraft(destination: locations[index])
                            }
                        }) {
                            Image(systemName: searchText.isEmpty ? "clock" : "magnifyingglass")
                                .foregroundColor(.blue)
                        }
                    }
                }
                // Remove background
                .listStyle(PlainListStyle())
                .onAppear() {
                    viewModel.appModel.fetchTripHistory();
                }
                .onChange(of: searchText) { oldValue, newValue in
                    if (!newValue.isEmpty) {
                        calculateSearch()
                    }
                }.onChange(of: viewModel.appModel.tripHistory) { oldValue, newValue in
                    if history.isEmpty {
                        calculateHistory()
                    }
                }
            }
        }
        .disabled(isLoading) // Si esta cargando, deshabilitar la vista
        .sheet(isPresented: $isShowingTripDetails, content: {
            DraftSheetView(draft: self.draft!)
        })
    }
    
    func calculateHistory() {
        let trips = viewModel.appModel.tripHistory;
        
        for trip in trips {
            lookUpCurrentLocation(coordinates: CLLocation(latitude: trip.destLat, longitude: trip.destLon)) { (placemark) in
                if let placemark = placemark {
                    // If history contains address, don't append
                    if (!history.contains(where: { $0.name == placemark.name })) {
                        history.append(placemark)
                    }
                }
            }
        }
    }
    
    func calculateSearch() {
        lookUpAllResultsForAddress(address: searchText) { (result) in
            // Comprobar que se ha encontrado algo
            if let placemarks = result {
                searchResults = placemarks
            }
        }
    }
    
    func processTripDraft(destination: CLPlacemark) {
        self.isLoading = true;
        
        let destinationAddress = formattedAddress(from: destination);
        let actualLocation = viewModel.getLastLocation();
        
        if (actualLocation != nil) {
            lookUpCurrentLocation(coordinates: actualLocation!) { result in
                if let result = result {
                    let currentAddress = formattedAddress(from: result);
                    
                    // Si la dirección de destino es igual a la dirección actual
                    if (currentAddress != destinationAddress) {
                        viewModel.createDraft(data: CreateTripDraftRequest.RequestBody(origin: currentAddress, destination: destinationAddress)) { response in
                            switch response {
                            case .success(let model):
                                // Mostrar el detalle del viaje en un modal
                                self.draft = model;
                                self.isShowingTripDetails = true;
                            case .failure(let error):
                                switch error {
                                case .INVALID_DISTANCE_BETWEEN:
                                    showDialog(title: "Error", description: String(localized: "La distancia entre las direcciones es demasiado pequeña o grande."));
                                    break;
                                default:
                                    showDialog(title: "Error", description: String(localized: "No se ha podido crear el viaje, inténtalo de nuevo."));
                                }
                            }
                            
                            self.isLoading = false;
                        }
                        
                    } else {
                        showDialog(title: "Error", description: String(localized: "No puedes viajar a la misma dirección en la que te encuentras."));
                        self.isLoading = false;
                    }
                } else {
                    showDialog(title: "Error", description: String(localized: "No se ha podido obtener tu ubicación actual, revisa los permisos de localización."));
                    self.isLoading = false;
                }
            }
        } else {
            showDialog(title: "Error", description: String(localized: "No se ha podido obtener tu ubicación actual, revisa los permisos de localización."));
            self.isLoading = false;
        }
    }
}

#Preview {
    TripsMenuView()
}
