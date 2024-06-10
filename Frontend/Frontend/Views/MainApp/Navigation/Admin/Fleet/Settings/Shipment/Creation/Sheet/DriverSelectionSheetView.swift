//
//  DriverSelectionSheetView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 22/5/24.
//

import SwiftUI

struct DriverSelectionSheetView: View {
    @EnvironmentObject var fleetModel: AdminFleetViewModel;
    @State private var searchText = "";
    
    @Binding var selectedDriver: UserModel?;
    @Binding var isPresented: Bool;
    
    private var filteredDrivers: [UserModel] {
        if searchText.isEmpty {
            return fleetModel.drivers;
        } else {
            return fleetModel.drivers.filter { driver in
                driver.fullName.lowercased().starts(with: searchText.lowercased());
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List(filteredDrivers) { driver in
                Button(action: {
                    selectedDriver = driver;
                    isPresented = false;
                }) {
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
}
