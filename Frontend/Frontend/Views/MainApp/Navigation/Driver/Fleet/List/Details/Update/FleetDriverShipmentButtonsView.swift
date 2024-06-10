//
//  FleetDriverShipmentButtonsVies.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 22/5/24.
//

import SwiftUI

struct FleetDriverShipmentButtonsView: View {
    
    @Binding var shipment: ShipmentModel;
    @State private var isStatusUpdatePresented: Bool = false;
    
    var body: some View {
        HStack {
            Button(action: {
                isStatusUpdatePresented.toggle()
            }, label: {
                Text("Cambiar el estado")
            })
            .padding()
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(10)
            .sheet(isPresented: $isStatusUpdatePresented, content: {
                FleetDriverShipmentStatusUpdateView(isPresented: $isStatusUpdatePresented, shipment: $shipment)
            })
        }.frame(maxWidth: .infinity)
        
    }
}
