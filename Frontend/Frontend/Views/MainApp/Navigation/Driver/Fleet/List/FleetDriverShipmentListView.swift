//
//  FleetDriverShipmentListView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 22/5/24.
//

import SwiftUI

struct FleetDriverShipmentListView: View {
    
    @EnvironmentObject var viewModel: FleetDriverViewModel;
    @State private var searchText = "";
    @State private var searchingBy = SearchType.Id;
    
    private var filteredShipments: [ShipmentModel] {
        if searchText.isEmpty {
            return viewModel.shipments;
        } else {
            switch searchingBy {
            case .Id:
                return viewModel.shipments.filter { shipment in
                    String("\(shipment.id)").contains(searchText);
                }
            case .SourceAddress:
                return viewModel.shipments.filter { shipment in
                    shipment.sourceAddress.lowercased().contains(searchText.lowercased());
                }
            case .DestionationAddress:
                return viewModel.shipments.filter { shipment in
                    shipment.destinationAddress.lowercased().contains(searchText.lowercased());
                }
            }
        }
    }
    
    var body: some View {
        List(filteredShipments) { shipment in
            NavigationLink(destination: FleetDriverShipmentDetails(shipment: shipment)
                .environmentObject(viewModel)) {
                ShipmentRow(shipment: shipment);
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .searchScopes($searchingBy, scopes: {
            ForEach(SearchType.allCases, id: \.self) { scope in
                Text(scope.name)
            }
        })
        .navigationTitle("Lista de envios")
        .navigationBarTitleDisplayMode(.inline)
        .refreshable {
            viewModel.fetchShipments()
        }.onAppear() {
            viewModel.fetchShipments()
        }
    }
    
    enum SearchType: String, CaseIterable {
        case Id, SourceAddress, DestionationAddress
        
        var name: String {
            switch self {
            case .SourceAddress:
               return "Dirección de origen"
            case .DestionationAddress:
                return "Dirección de destino"
            case .Id:
                return "Identificador"
            }
        }
    }
}
