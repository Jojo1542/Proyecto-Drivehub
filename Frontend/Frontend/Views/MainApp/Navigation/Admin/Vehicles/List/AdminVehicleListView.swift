//
//  AdminVehicleListView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 21/5/24.
//

import SwiftUI

struct AdminVehicleListView: View {
    
    @EnvironmentObject var viewModel: AdminVehicleViewModel;
    @State private var searchText = "";
    @State private var searchingBy = SearchType.Brand;
    
    private var filteredVehicles: [RentCarModel] {
        if searchText.isEmpty {
            return viewModel.vehicles;
        } else {
            switch searchingBy {
            case .Brand:
                return viewModel.vehicles.filter { vehicle in
                    vehicle.brand.lowercased().contains(searchText.lowercased());
                }
            case .Model:
                return viewModel.vehicles.filter { vehicle in
                    vehicle.model.lowercased().contains(searchText.lowercased());
                }
            case .Plate:
                return viewModel.vehicles.filter { vehicle in
                    vehicle.plate.lowercased().contains(searchText.lowercased());
                }
            }
        }
    }
    
    var body: some View {
        List(filteredVehicles) { vehicle in
            NavigationLink(destination: AdminVehicleDetailView(vehicle: vehicle).environmentObject(viewModel)) {
                AdminVehicleRow(vehicle: vehicle)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            processRemove(id: vehicle.id);
                        } label: {
                            Label("Eliminar", systemImage: "trash")
                        }
                    }
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .searchScopes($searchingBy, scopes: {
            ForEach(SearchType.allCases, id: \.self) { scope in
                Text(scope.name)
            }
        })
        .navigationTitle("Lista de vehiculos")
        .onAppear() {
            viewModel.fetchVehicles();
        }
        .refreshable() {
            viewModel.fetchVehicles();
        }
    }
    
    enum SearchType: String, CaseIterable {
        case Brand, Model, Plate
        
        var name: String {
            switch self {
            case .Brand:
                return String(localized: "Marca")
            case .Model:
                return String(localized: "Modelo")
            case .Plate:
                return String(localized: "Matrícula")
            }
        }
    }
        
    func processRemove(id: Int) {
        viewModel.deleteVehicle(vehicleId: id, completion: { result in
            switch result {
                case .success(_):
                    showDialog(title: "Vehiculo eliminado", description: "El vehiculo ha sido eliminado correctamente");
                case .failure(let error):
                    showDialog(title: "Error", description: "Ha ocurrido un error al eliminar el vehiculo: \(error!)")
            }
        });
    }
}

#Preview {
    let authModel = PreviewHelper.authModelAdmin;
    let appModel = AppViewModel(authViewModel: authModel);
    
    return AdminVehicleListView()
        .environmentObject(authModel)
        .environmentObject(appModel)
        .environmentObject(AdminVehicleViewModel(appModel: appModel))
}
