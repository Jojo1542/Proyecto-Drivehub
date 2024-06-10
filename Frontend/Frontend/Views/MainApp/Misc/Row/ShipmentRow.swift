//
//  AdminShipmentRow.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 21/5/24.
//

import SwiftUI

struct ShipmentRow: View {
    
    var shipment: ShipmentModel;
    
    var body: some View {
        HStack {
            Image(systemName: "shippingbox.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .padding(5)
                .background(Color.accentColor)
                .cornerRadius(10)
                .foregroundColor(.white)
            
            VStack(alignment: .leading) {
                Text("\(shipment.id)")
                    .font(.title)
                    .bold()
                
                // Estado
                Text(shipment.actualStatus.userFriendlyName)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack {
                    Text(shipment.sourceAddress)
                    Image(systemName: "arrow.right")
                        .foregroundColor(.accentColor)
                    Text(shipment.destinationAddress)
                }
            }
        }
    }
}
