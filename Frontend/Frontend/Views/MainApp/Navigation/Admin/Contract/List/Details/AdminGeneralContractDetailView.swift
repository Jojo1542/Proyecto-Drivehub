//
//  AdminGeneralContractDetailView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 28/5/24.
//

import SwiftUI

struct AdminGeneralContractDetailView: View {
    
    @EnvironmentObject var viewModel: AdminContractViewModel;
    
    var contract: ContractModel;
    
    var body: some View {
        List {
            Section("Información") {
                HStack {
                    Text("Identificador")
                        .font(.headline)
                        .bold()
                    Spacer()
                    Text("\(contract.id)")
                        .font(.subheadline)
                }
                
                HStack {
                    Text("Estado")
                        .font(.headline)
                        .bold()
                    Spacer()
                    Text(contract.expired ? "Caducado" : "Activo")
                        .font(.subheadline)
                }
            }
            
            Section("Validez") {
                HStack {
                    Text("Fecha de inicio")
                        .font(.headline)
                        .bold()
                    Spacer()
                    Text(contract.startDate.formatted(date: .complete, time: .omitted))
                        .font(.subheadline)
                }
                
                HStack {
                    Text("Fecha de fin")
                        .font(.headline)
                        .bold()
                    Spacer()
                    Text(contract.endDate.formatted(date: .complete, time: .omitted))
                        .font(.subheadline)
                }
            }
            
            
            if (contract.driverData != nil) {
                Section("Usuario") {
                    UserRow(user: contract.driverData!)
                }
            }
            
            if (canFinalize()) {
                // Botón de finalizar contrato
                Button(action: {
                    processFinalize();
                }) {
                    Text("Finalizar contrato")
                        .foregroundColor(.red)
                }
            }
        }
    }
    
    func canFinalize() -> Bool {
        return !contract.expired || (contract.driverData?.roles.contains(UserModel.Role.CHAUFFEUR) ?? false)
    }
    
    func processFinalize() {
        viewModel.finalizeContract(contractId: contract.id) { result in
            switch result {
            case .success(_):
                showDialog(title: "Contrato finalizado", description: "El contrato ha sido finalizado correctamente");
            case .failure(let error):
                showDialog(title: "Error", description: "No se ha podido finalizar el contrato. Error: \(error ?? 0)");
            }
        }
    }
}
