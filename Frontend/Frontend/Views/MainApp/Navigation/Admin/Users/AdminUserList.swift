//
//  AdminUserList.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 30/5/24.
//

import SwiftUI

struct AdminUserList: View {
    
    @EnvironmentObject var viewModel: AdminUserViewModel;
    @State private var searchText = "";
    @State private var searchingBy = SearchType.FullName;
    
    private var filteredUsers: [UserModel] {
        if searchText.isEmpty {
            return viewModel.users;
        } else {
            switch searchingBy {
            case .FullName:
                return viewModel.users.filter { user in
                    user.fullName.lowercased().contains(searchText.lowercased());
                }
            case .DNI:
                return viewModel.users.filter { user in
                    if let dni = user.dni {
                        return dni.lowercased().contains(searchText.lowercased());
                    } else {
                        return false;
                    }
                }
            }
        }
    }
    
    var body: some View {
        List(filteredUsers) { user in
            NavigationLink(destination: AdminUserDetailsView(user: user).environmentObject(viewModel)) {
                UserRow(user: user);
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .searchScopes($searchingBy, scopes: {
            ForEach(SearchType.allCases, id: \.self) { scope in
                Text(scope.name)
            }
        })
        .navigationTitle("Lista de Usuarios")
        .refreshable {
            viewModel.fetchUsers()
        }.onAppear() {
            viewModel.fetchUsers()
        }
    }
    
    enum SearchType: String, CaseIterable {
        case FullName, DNI
        
        var name: String {
            switch self {
            case .FullName:
                return String(localized: "Nombre")
            case .DNI:
                return String(localized: "DNI")
            }
        }
    }
}
