//
//  UserSelectionSheetView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 28/5/24.
//

import SwiftUI

struct FleetUserSelectionSheetView: View {
    @EnvironmentObject var viewModel: AdminFleetViewModel;
    @State private var searchText = "";
    
    @Binding var selectedUser: UserModel?;
    @Binding var isPresented: Bool;
    
    private var filteredUsers: [UserModel] {
        if searchText.isEmpty {
            return viewModel.allUsers;
        } else {
            return viewModel.allUsers.filter { driver in
                driver.fullName.lowercased().starts(with: searchText.lowercased());
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List(filteredUsers) { driver in
                Button(action: {
                    selectedUser = driver;
                    isPresented = false;
                }) {
                    UserRow(user: driver);
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .navigationTitle("Lista de Usuarios")
            .refreshable {
                viewModel.fetchAllUsers()
            }.onAppear() {
                viewModel.fetchAllUsers()
            }
        }
    }
}
