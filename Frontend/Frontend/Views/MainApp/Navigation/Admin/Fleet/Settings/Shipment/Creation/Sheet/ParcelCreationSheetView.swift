//
//  ParcelCreationSheetView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 22/5/24.
//

import SwiftUI

struct ParcelCreationSheetView: View {

    @Binding var parcels: [CreateShipmentRequest.RequestBody.Parcel];
    @Binding var isPresented: Bool;
    
    @State private var content: String = ""
    @State private var quantity: Int = 1
    @State private var weight: Double = 1.0
    
    var body: some View {
        Form {
            Section(header: Text("Información del paquete")) {
                TextField("Contenido", text: $content)
                Stepper("Cantidad: \(quantity)", value: $quantity, in: 1...100)
                Stepper("Peso: \(weight.formatted()) kg", value: $weight, in: 1...1000, step: 0.1)
            }
            
            Button(action: {
                parcels.append(CreateShipmentRequest.RequestBody.Parcel(content: content, quantity: quantity, weight: weight))
                isPresented = false
            }, label: {
                Label("Añadir paquete", systemImage: "plus")
            })
        }
    }
}
