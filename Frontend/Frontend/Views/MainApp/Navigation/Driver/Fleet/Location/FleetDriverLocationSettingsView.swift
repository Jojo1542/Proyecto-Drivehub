//
//  FleetDriverLocationSettingsView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 22/5/24.
//

import SwiftUI

struct FleetDriverLocationSettingsView: View {
    
    @EnvironmentObject var viewModel: FleetDriverViewModel;
    
    @State var isLocationTrackingEnabled: Bool = false;
    
    var body: some View {
        // Toggle button to enable or disable location tracking
        // Too, a map showing the current location
        // Finally, a description of why we need the location
        Form {
            Section(header: Text("Configuración de la localización")) {
                Toggle("Activar seguimiento de localización", isOn: $isLocationTrackingEnabled)
                    .onChange(of: isLocationTrackingEnabled) { oldValue, newValue in
                        handleLocationTrackingChange(isEnabled: newValue)
                    }
            }
            
            Section(header: Text("Mapa de la localización")) {
                // Show the map if location tracking is enabled, if not, show a message
                if (isLocationTrackingEnabled) {
                    MapView(followUser: true)
                        .disabled(true)
                        .frame(height: 300)
                } else {
                    Text("Activa el seguimiento de la localización para ver tu ubicación en el mapa.")
                        .frame(height: 300)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Ajustes de ubicación")
        .onAppear() {
            isLocationTrackingEnabled = viewModel.isUpdatingLocation();
        }
    }
    
    func handleLocationTrackingChange(isEnabled: Bool) {
        if isEnabled {
            viewModel.startUpdatingLocation()
        } else {
            viewModel.stopUpdatingLocation()
        }
    }
}

#Preview {
    let authModel = PreviewHelper.authModelFleetDriver;
    let appModel = AppViewModel(authViewModel: authModel);
    let driverModel = DriverViewModel(appModel: appModel);
    
    return FleetDriverLocationSettingsView()
        .environmentObject(FleetDriverViewModel(driverModel: driverModel))
        .environmentObject(driverModel)
        .environmentObject(authModel)
        .environmentObject(appModel)
}
