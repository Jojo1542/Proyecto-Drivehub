//
//  ShipmentDetailsView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 19/5/24.
//

import SwiftUI
import CoreLocation

struct ShipmentDetailsView: View {
    
    var shipment: ShipmentModel;
    
    var body: some View {
        List {
            ShipmentDataView(shipment: shipment)
        }
        .navigationTitle("Detalles del envio \(shipment.id)")
    }
}

#Preview {
    NavigationView {
        ShipmentDetailsView(shipment: PreviewHelper.exampleShipment)
    }
}
