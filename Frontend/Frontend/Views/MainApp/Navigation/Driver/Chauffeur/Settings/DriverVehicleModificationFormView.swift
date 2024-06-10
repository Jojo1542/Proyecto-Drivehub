//
//  DriverVehicleModificationFormView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 25/5/24.
//

import SwiftUI

struct DriverVehicleModificationFormView: View {
    
    @EnvironmentObject var viewModel: ChauffeurDriverViewModel;
    @EnvironmentObject var authModel: AuthViewModel;
    
    @State var vehiclePlate: String = "";
    @State var vehicleModel: String = "";
    @State var vehicleColor: String = "";
    
    var body: some View {
        Form {
            Section(header: Text("Información del vehículo")) {
                TextField("Matrícula", text: $vehiclePlate)
                TextField("Modelo", text: $vehicleModel)
                TextField("Color", text: $vehicleColor)
            }
            
            Section {
                Button(action: {
                    processUpdate()
                }, label: {
                    HStack {
                        Spacer();
                        Text("Guardar cambios")
                        Spacer();
                    }
                })
            }
        }
        .onAppear() {
            if let data = authModel.currentUser?.driverData {
                vehiclePlate = data.vehiclePlate ?? "";
                vehicleModel = data.vehicleModel ?? "";
                vehicleColor = data.vehicleColor ?? "";
            }
        }
        .navigationTitle("Modificar vehículo")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func processUpdate() {
        viewModel.updateVehicleData(vehiclePlate: vehiclePlate, vehicleModel: vehicleModel, vehicleColor: vehicleColor) { result in
            switch result {
            case .success(_):
                authModel.currentUser?.driverData?.vehiclePlate = vehiclePlate;
                authModel.currentUser?.driverData?.vehicleModel = vehicleModel;
                authModel.currentUser?.driverData?.vehicleColor = vehicleColor;
                
                showDialog(title: "Cambios guardados", description: "Los cambios se han guardado correctamente.");
                break;
            case .failure(let error):
                showDialog(title: "Error", description: "No se han podido guardar los cambios. Error: \(error ?? 0)")
                break;
            }
        }
    }
}

#Preview {
    DriverVehicleModificationFormView()
}
