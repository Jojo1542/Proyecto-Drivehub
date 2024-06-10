//
//  CreateFleetFormView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 21/5/24.
//

import SwiftUI

struct CreateFleetFormView: View {
    
    @EnvironmentObject var viewModel: AdminFleetViewModel;
    @Environment(\.presentationMode) var presentationMode;
    
    @State var name = ""
    @State var cif = ""
    @State var vehicleType = FleetModel.VahicleType.CAR
    @State var loading = false;
    
    var body: some View {
        Form {
            Section(header: Text("Información de la flota")) {
                TextField("Nombre de la flota", text: $name)
                TextField("CIF de la flota", text: $cif)
                Picker("Tipo de vehículo", selection: $vehicleType) {
                    ForEach(FleetModel.VahicleType.allCases, id: \.self) { vehicleType in
                        Text(vehicleType.name).tag(vehicleType)
                    }
                }
            }
            
            VStack(alignment: .center) {
                Button(action: {
                    withAnimation(.bouncy) {
                        self.loading = true;
                        processCreate();
                    }
                }) {
                    if (!loading) {
                        Text("Crear flota")
                            .frame(maxWidth: .infinity)
                    } else {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                    }
                }
                .disabled(loading)
                .padding()
                .foregroundColor(.white)
                .background(Color.accentColor)
                .cornerRadius(10)
            }.frame(maxWidth: .infinity)
        }
        .navigationTitle("Crear una nueva flota")
    }
    
    func processCreate() {
        self.viewModel.createFleet(data: CreateFleetRequest.RequestBody(
            name: self.name,
            CIF: self.cif,
            vehicleType: self.vehicleType.rawValue
        )) { result in
            self.loading = false
            
            switch result {
                case .success(let data):
                    showDialog(title: "Flota creada", description: "La flota ha sido creada correctamente.")
                    self.presentationMode.wrappedValue.dismiss(); // Volver a la lista
                case .failure(let error):
                    switch error {
                        case .CIF_ALREADY_EXISTS:
                            showDialog(title: "Error", description: "El CIF ya está en uso.")
                        break;
                        default:
                            showDialog(title: "Error", description: "Ha ocurrido un error al crear la flota.")
                        break;
                    }
            }
        }
    }
}

#Preview {
    CreateFleetFormView()
}
