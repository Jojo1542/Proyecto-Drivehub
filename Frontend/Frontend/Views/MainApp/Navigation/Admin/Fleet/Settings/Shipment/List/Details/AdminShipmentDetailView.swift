//
//  AdminShipmentDetailView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 21/5/24.
//

import SwiftUI

struct AdminShipmentDetailView: View {
    
    @State var shipment: ShipmentModel;

    var body: some View {
        VStack {
            // Mostrar datos del envío como si fuera el normal
            ShipmentDetailsView(shipment: $shipment)
            
            // Barra abajo que muestra el estado del envío y permite cambiarlo
            AdminShipmentModificationBarView(shipment: $shipment)
        }
    }
}

#Preview {
    AdminShipmentDetailView(shipment: PreviewHelper.exampleShipment)
}
