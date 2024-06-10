//
//  ShipmentsMainView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 16/5/24.
//

import SwiftUI

struct ShipmentsMainView: View {
    
    @Environment(\.colorScheme) var colorScheme;
    
    @EnvironmentObject var viewModel: ShipmentViewModel;
    
    @State private var isDetailPresented: Bool = false;
    @State private var shipmentCode: String = "";
    @State private var shipment: ShipmentModel?;
    @FocusState private var isFocused: Bool;
    
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .fill(colorScheme == .dark ? Color.black : Color.white)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Titulo de insertar codigo de envio
                    Text("Insertar código de envio")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                    
                    // Barra donde escribir el código de envio
                    TextField("Código de envio", text: $shipmentCode)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding()
                        .keyboardType(.numberPad)
                        .scrollDismissesKeyboard(.interactively)
                        .focused($isFocused)
                    
                    // Boton que busca el envio y envia a la vista de detalles
                    // Primero busca el envio, y luego envia a la vista de detalles, por lo cual no podría usar un NavigationView directamente
                    Button(action: {
                        searchShipment()
                    }) {
                        Text("Buscar envio")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .navigationDestination(isPresented: $isDetailPresented) {
                        if (shipment != nil) {
                            ShipmentDetailsView(shipment: .constant(shipment!))
                        } else {
                            EmptyView()
                        }
                    }
                }
            }.onTapGesture {
                isFocused = false
            }
        }
    }
    
    func searchShipment() {
        if !shipmentCode.isEmpty {
            viewModel.findShipment(shipmentId: Int(shipmentCode) ?? 0) { result in
                switch result {
                case .success(let shipment):
                    self.shipment = shipment;
                    self.isDetailPresented = true;
                    print ("Envio encontrado: \(shipment)")
                case .failure(let error):
                    if (error == 404) {
                        showDialog(title: "Envio no encontrado", description: "No se ha encontrado ningun envio con el código \(shipmentCode)")
                    } else {
                        showDialog(title: "Error", description: "Ha ocurrido un error desconocido al buscar el envio")
                    }
                }
            }
        } else {
            showDialog(title: "Error", description: "Por favor, inserte un código de envio")
        }
    }
}

#Preview {
    let authModel = AuthViewModel();
    let appModel = AppViewModel(authViewModel: authModel);
    
    return ShipmentsMainView()
        .environmentObject(authModel)
        .environmentObject(appModel)
        .environmentObject(ShipmentViewModel(appViewModel: appModel))
}
