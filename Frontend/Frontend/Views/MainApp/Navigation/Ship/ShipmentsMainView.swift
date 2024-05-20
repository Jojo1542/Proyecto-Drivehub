//
//  ShipmentsMainView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 16/5/24.
//

import SwiftUI

struct ShipmentsMainView: View {
    
    @State private var isDetailPresented: Bool = false;
    @State private var shipmentCode: String = "";
    @State private var shipment: ShipmentModel?;
    
    var body: some View {
        NavigationView {
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
                
                // Boton que busca el envio y envia a la vista de detalles
                // Primero busca el envio, y luego envia a la vista de detalles, por lo cual no podría usar un NavigationView directamente
                Button(action: {
                    // Ir a la vista de detalles
                    self.isDetailPresented = true;
                }) {
                    Text("Buscar envio")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .navigationDestination(isPresented: $isDetailPresented) {
                    EmptyView()
                }
            }
        }
    }
}

#Preview {
    let authModel = AuthViewModel();
    let appModel = AppViewModel(authViewModel: authModel);
    
    return ShipmentsMainView()
        .environmentObject(authModel)
        .environmentObject(appModel)
}
