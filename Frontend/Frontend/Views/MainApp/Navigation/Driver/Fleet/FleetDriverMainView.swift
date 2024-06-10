//
//  FleetDriverMainView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 24/4/24.
//

import SwiftUI

struct FleetDriverMainView: View {
    
    @EnvironmentObject var viewModel: FleetDriverViewModel;
    
    var body: some View {
        NavigationView {
            List {
                // Lista de envios asignados
                NavigationLink(destination: FleetDriverShipmentListView(), label: { Label("Lista de envios", systemImage: "shippingbox.fill") });
                
                // Compartición de ubicación
                NavigationLink(destination: FleetDriverLocationSettingsView(), label: { Label("Modo de ubicación", systemImage: "location.fill") });
                
                // Información sobre mi flota
                NavigationLink(destination: DriverFleetInfoView(), label: { Label("Mi flota", systemImage: "person.3.sequence.fill") });
            }
            .navigationTitle("Conductor de flota")
            .navigationBarTitleDisplayMode(/*@START_MENU_TOKEN@*/.automatic/*@END_MENU_TOKEN@*/)
        }
    }
}

#Preview {
    let authModel = PreviewHelper.authModelFleetDriver;
    let appModel = AppViewModel(authViewModel: authModel);
    let driverModel = DriverViewModel(appModel: appModel);
    
    return FleetDriverMainView()
        .environmentObject(FleetDriverViewModel(driverModel: driverModel))
        .environmentObject(driverModel)
        .environmentObject(authModel)
        .environmentObject(appModel)
}
