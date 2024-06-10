//
//  ShipmentParcelListView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 20/5/24.
//

import SwiftUI

struct ShipmentParcelListView: View {
    
    var shipment: ShipmentModel;
    
    var body: some View {
        Section(header: Text("Conteindo")) {
            ForEach(shipment.parcels) { parcel in
                ParcelRowView(parcel: parcel)
            }
        }
    }
}
