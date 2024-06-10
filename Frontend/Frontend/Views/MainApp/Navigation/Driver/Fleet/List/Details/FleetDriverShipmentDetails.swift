//
//  FleetDriverShipmentDetails.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 22/5/24.
//

import SwiftUI

struct FleetDriverShipmentDetails: View {
    
    @State var shipment: ShipmentModel;
    
    var body: some View {
        VStack {
            // Mostrar datos del envío como si fuera el normal
            ShipmentDetailsView(shipment: $shipment)
            
            // Barra abajo que permite
            FleetDriverShipmentButtonsView(shipment: $shipment)
        }
    }
}
