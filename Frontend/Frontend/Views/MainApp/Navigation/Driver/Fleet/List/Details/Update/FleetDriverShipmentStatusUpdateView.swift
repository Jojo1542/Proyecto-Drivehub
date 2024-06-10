//
//  FleetDriverShipmentStatusUpdateView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 22/5/24.
//

import SwiftUI

struct FleetDriverShipmentStatusUpdateView: View {
    
    typealias StatusType = ShipmentModel.StatusHistory.StatusType;
    
    @EnvironmentObject var viewModel: FleetDriverViewModel;
    @Binding var isPresented: Bool;
    
    @Binding var shipment: ShipmentModel;
    @State var loading: Bool = false;
    
    @State var status: StatusType = StatusType.PENDING_TO_DELIVER;
    @State var description: String = "";
    
    var body: some View {
        Form {
            Section {
                Picker("Estado", selection: $status) {
                    ForEach(StatusType.allCases, id: \.self) { status in
                        Text(status.userFriendlyName)
                    }
                }
            }
            
            Section {
                TextField("Description", text: $description,  axis: .vertical)
                    .lineLimit(5...10)
            }
            
            Section {
                Button(action: {
                    withAnimation(.bouncy) {
                        // Actualizar el estado del envío
                        self.updateShipmentStatus()
                    }
                }, label: {
                    Text("Actualizar estado")
                })
            }
        }
    }
    
    func updateShipmentStatus() {
        self.loading = true;
        
        self.viewModel.updateShipmentStatus(
            shipmentId: shipment.id,
            newStatus: UpdateShipmentStatusRequest.RequestBody(
                updateDate: Date(),
                status: status.rawValue,
                description: description.isEmpty ? nil : description
            )) { result in
                switch result {
                    case .success(_):
                        self.loading = false;
                        self.isPresented = false;
                        showDialog(title: "Estado actualizado", description: "El estado del envío ha sido actualizado correctamente")
                    case .failure(let error):
                        print("Update shipment status failed with error \(error!)")
                        showDialog(title: "Error", description: "Ha ocurrido un error al actualizar el estado del envío")
                }
            }
    }
}
