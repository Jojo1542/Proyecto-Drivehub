//
//  ShipmentDetailsView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 19/5/24.
//

import SwiftUI
import CoreLocation

struct ShipmentDetailsView: View {
    
    @Binding var shipment: ShipmentModel;
    
    var body: some View {
        List {
            ShipmentDataView(shipment: shipment)
            ShipmentParcelListView(shipment: shipment)
            
            if (shipment.driver != nil) {
                ShipmentDriverInfoView(driver: shipment.driver!)
            }
            
            ShipmentHistoryListView(shipment: shipment)
        }
        .navigationTitle("Detalles del envio \"\(shipment.id)\"")
    }
}
