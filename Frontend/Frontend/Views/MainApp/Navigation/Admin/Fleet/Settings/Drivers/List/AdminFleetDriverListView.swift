//
//  AdminFleetDriverListView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 22/5/24.
//

import SwiftUI

struct AdminFleetDriverListView: View {
    
    @EnvironmentObject var fleetModel: AdminFleetViewModel;
    
    @State private var searchText = "";
    
    private var filteredDrivers: [UserModel] {
        if searchText.isEmpty {
            return fleetModel.drivers;
        } else {
            return fleetModel.drivers.filter { driver in
                driver.firstName.lowercased().contains(searchText.lowercased());
            }
        }
    }
    
    var body: some View {
        List(filteredDrivers) { driver in
            NavigationLink(destination: EmptyView()) {
                UserRow(user: driver);
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .navigationTitle("Lista de conductores")
        .refreshable {
            fleetModel.fetchDrivers()
        }.onAppear() {
            fleetModel.fetchDrivers()
        }
    }
}

#Preview {
    let authModel = PreviewHelper.authModelAdmin;
    let appModel = AppViewModel(authViewModel: authModel);
    
    return NavigationView {
        AdminFleetDriverListView()
            .environmentObject(authModel)
            .environmentObject(appModel)
            .environmentObject(AdminFleetViewModel(appModel: appModel))
    }
}
