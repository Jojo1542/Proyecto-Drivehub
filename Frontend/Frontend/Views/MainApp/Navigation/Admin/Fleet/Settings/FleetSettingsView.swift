//
//  FleetSettingsView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 21/5/24.
//

import SwiftUI

struct FleetSettingsView: View {
    
    @EnvironmentObject var viewModel: AdminFleetViewModel;
    
    var fleet: FleetModel;
    
    var body: some View {
        VStack {
            List {
                Section(header: ListSectionHeader(title: "Gestión de Envios", icon: "shippingbox.fill")) {
                    
                    NavigationLink(destination: AdminShipmentListView().environmentObject(AdminShipmentViewModel(appModel: viewModel.appViewModel, fleetId: fleet.id)),
                        label: { Label("Lista de Envios", systemImage: "shippingbox.fill")
                    });
                    
                    NavigationLink(
                        destination: ShipmentCreationFormView().environmentObject(AdminShipmentViewModel(appModel: viewModel.appViewModel, fleetId: fleet.id)).environmentObject(viewModel),
                        label: { Label("Crear nuevo envio", systemImage: "plus.circle.fill")
                    });
                }
                
                // Gestión de empleados
                Section(header: ListSectionHeader(title: "Gestión de Conductores", icon: "person.3.fill")) {
                    NavigationLink(
                        destination: AdminFleetDriverListView().environmentObject(viewModel),
                        label: { Label("Lista de conductores", systemImage: "person.3.fill")
                    });
                    
                    // Contratos activos
                    NavigationLink(
                        destination: FleetContractListView().environmentObject(viewModel),
                        label: { Label("Listar contratos", systemImage: "doc.text.fill")
                    });
                    
                    // Crear nuevo contrato
                    NavigationLink(
                        destination: FleetContractCreationView().environmentObject(viewModel),
                        label: { Label("Crear nuevo contrato", systemImage: "plus.circle.fill")
                    });
                }
            }
        }
        .navigationTitle("\(fleet.name)")
        .onAppear {
            viewModel.fleetId = fleet.id;
            viewModel.fetchDrivers() // Cargar los conductores
        }
    }
}

#Preview {
    let authModel = PreviewHelper.authModelAdmin;
    let appModel = AppViewModel(authViewModel: authModel);
    
    return NavigationView {
        FleetSettingsView(fleet: PreviewHelper.exampleFleet)
            .environmentObject(authModel)
            .environmentObject(appModel)
            .environmentObject(AdminFleetViewModel(appModel: appModel))
    }
}
