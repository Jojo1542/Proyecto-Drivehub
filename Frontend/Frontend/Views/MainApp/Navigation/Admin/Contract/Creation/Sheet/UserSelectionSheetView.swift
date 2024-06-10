//
//  UserSelectionSheetView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 28/5/24.
//

import SwiftUI

struct UserSelectionSheetView: View {
    @EnvironmentObject var viewModel: AdminContractViewModel;
    @State private var searchText = "";
    
    @Binding var selectedUser: UserModel?;
    @Binding var isPresented: Bool;
    
    private var filteredUsers: [UserModel] {
        if searchText.isEmpty {
            return viewModel.users;
        } else {
            return viewModel.users.filter { driver in
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
                viewModel.fetchUsers()
            }.onAppear() {
                viewModel.fetchUsers()
            }
        }
    }
}
