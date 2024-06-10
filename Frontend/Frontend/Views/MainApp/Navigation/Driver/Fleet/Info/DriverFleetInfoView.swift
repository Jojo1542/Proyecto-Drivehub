//
//  DriverFleetInfoView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 22/5/24.
//

import SwiftUI

struct DriverFleetInfoView: View {
    
    @EnvironmentObject var viewModel: FleetDriverViewModel;
    
    var body: some View {
        List {
            if let fleet = viewModel.fleet {
                Section(header: Text("Información de la flota")) {
                    HStack {
                        Text("Nombre")
                        Spacer()
                        Text(fleet.name)
                    }
                    HStack {
                        Text("CIF")
                        Spacer()
                        Text(fleet.cif)
                    }
                    HStack {
                        Text("Tipo de vehículos")
                        Spacer()
                        Text("\(fleet.vehicleType)")
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Mi flota")
        .disabled(true)
        .onAppear() {
            viewModel.fetchFleet()
        }
    }
}

#Preview {
    let authModel = PreviewHelper.authModelFleetDriver;
    let appModel = AppViewModel(authViewModel: authModel);
    let driverModel = DriverViewModel(appModel: appModel);
    
    return DriverFleetInfoView()
        .environmentObject(FleetDriverViewModel(driverModel: driverModel))
        .environmentObject(driverModel)
        .environmentObject(authModel)
        .environmentObject(appModel)
}
