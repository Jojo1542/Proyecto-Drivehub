//
//  FleetListView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 21/5/24.
//

import SwiftUI

struct FleetListView: View {
    
    @EnvironmentObject var viewModel: AdminFleetViewModel;
    var asSuperadmin: Bool = false;
    @State private var searchText = "";
    
    var filteredFleet: [FleetModel] {
        if searchText.isEmpty {
            return viewModel.fleets;
        } else {
            return viewModel.fleets.filter { fleet in
                fleet.name.lowercased().contains(searchText.lowercased());
            }
        }
    }
    
    var body: some View {
        List() {
            if (!asSuperadmin) {
                // Button to add a new driver license
                NavigationLink(destination: CreateFleetFormView().environmentObject(viewModel)) {
                    HStack {
                        Image(systemName: "plus.circle")
                        Text("Crear una nueva flota")
                    }
                    .foregroundColor(.accentColor)
                }
            }
            
            ForEach(filteredFleet) { fleet in
                NavigationLink(destination: FleetSettingsView(fleet: fleet).environmentObject(viewModel)) {
                    FleetRow(fleet: fleet);
                }
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .navigationTitle("Lista de flotas")
        .onAppear() {
            viewModel.fetchFleets(superAdmin: asSuperadmin);
        }
        .refreshable() {
            viewModel.fetchFleets(superAdmin: asSuperadmin);
        }
    }
}

#Preview {
    let authModel = PreviewHelper.authModelAdmin;
    let appModel = AppViewModel(authViewModel: authModel);
    
    return ShipmentCreationFormView()
        .environmentObject(authModel)
        .environmentObject(appModel)
        .environmentObject(AdminFleetViewModel(appModel: appModel))
}
