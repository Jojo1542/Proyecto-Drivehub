//
//  AdminGeneralContractCreationView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 28/5/24.
//

import SwiftUI

struct FleetContractCreationView: View {
    
    @EnvironmentObject var viewModel: AdminFleetViewModel;
    
    @State var user: UserModel? = nil;
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    @State var salary: Double = 700;
    
    @State var showUserSelection = false;
    
    var body: some View {
        Form {
            Section(header: Text("Usuario")) {
                // Información del conductor
                if (user == nil) {
                    Text("Usuario no seleccionado");
                } else {
                    // Información del conductor
                    UserRow(user: user!)
                }
                
                // Botón para asignar conductor
                Button(action: {
                    self.showUserSelection = true;
                }, label: {
                    Label("Seleccionar Usuario", systemImage: "person");
                }).sheet(isPresented: $showUserSelection, content: {
                    FleetUserSelectionSheetView(selectedUser: $user, isPresented: $showUserSelection)
                        .environmentObject(viewModel);
                });
            }
            
            Section("Validez") {
                DatePicker("Fecha de inicio", selection: $startDate, in: Date()..., displayedComponents: .date);
                DatePicker("Fecha de fin", selection: $endDate, in: startDate..., displayedComponents: .date);
            }
            
            Section("Salario") {
                TextField("Salario", value: $salary, formatter: NumberFormatter());
            }
            
            Section {
                Button(action: {
                    processCreate()
                }, label: {
                    Label("Crear contrato", systemImage: "checkmark");
                });
            }
        }
    }
    
    func processCreate() {
        if user != nil {
            if endDate > startDate {
                if salary > 700 {
                    viewModel.createContract(data: CreateContractRequest.RequestBody(
                        driverId: user!.id,
                        startDate: startDate,
                        endDate: endDate,
                        salary: salary,
                        fleetId: viewModel.fleetId!
                    )) { result in
                        switch result {
                        case .success(_):
                            showDialog(title: "Contrato creado", description: "El contrato ha sido creado correctamente.")
                            
                            // Reset form
                            user = nil;
                            startDate = Date();
                            endDate = Date();
                            salary = 0;
                        case .failure(let error):
                            showDialog(title: "Error", description: "No se ha podido crear el contrato.")
                        }
                    }
                } else {
                    showDialog(title: "Error", description: "El salario debe ser mayor a 700€.")
                }
            } else {
                showDialog(title: "Error", description: "La fecha de fin debe ser posterior a la fecha de inicio.")
            }
        } else {
            showDialog(title: "Error", description: "No se ha seleccionado un usuario para el contrato.")
        }
    }
}
