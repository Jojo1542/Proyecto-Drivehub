//
//  AdminGeneralContractListView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 28/5/24.
//

import SwiftUI

struct FleetContractListView: View {
    
    @EnvironmentObject var viewModel: AdminFleetViewModel;
    @State private var searchText = "";
    @State private var searchingBy = SearchType.FullName;
    
    var filteredContracts: [ContractModel] {
        if searchText.isEmpty {
            return viewModel.contracts;
        } else {
            switch searchingBy {
            case .Id:
                return viewModel.contracts.filter { contract in
                    String(contract.id).lowercased().starts(with: searchText.lowercased());
                }
            case .FullName:
                return viewModel.contracts.filter { contract in
                    (contract.driverData?.fullName.lowercased() ?? "") .contains(searchText.lowercased());
                }
            case .DNI:
                return viewModel.contracts.filter { contract in
                    (contract.driverData?.dni?.lowercased() ?? "") .contains(searchText.lowercased());
                    
                }
            }
        }
    }
    
    var body: some View {
        List(filteredContracts) { contract in
            NavigationLink(destination: AdminGeneralContractDetailView(contract: contract).environmentObject(viewModel)) {
                AdminContractRow(contract: contract);
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .searchScopes($searchingBy, scopes: {
            ForEach(SearchType.allCases, id: \.self) { scope in
                Text(scope.name)
            }
        })
        .navigationTitle("Lista de Contratos")
        .refreshable {
            viewModel.fetchContracts()
        }.onAppear() {
            viewModel.fetchContracts()
        }
    }
    
    enum SearchType: String, CaseIterable {
        case Id, FullName, DNI
        
        var name: String {
            switch self {
            case .Id:
                return String(localized: "Id")
            case .FullName:
                return String(localized: "Nombre")
            case .DNI:
                return String(localized: "DNI")
            }
        }
    }
}

