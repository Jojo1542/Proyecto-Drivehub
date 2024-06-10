//
//  ParcelRowView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 20/5/24.
//

import SwiftUI

struct ParcelRowView: View {
    
    var parcel: ShipmentModel.Parcel;
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(parcel.content)
                    .font(.headline)
                Text("Cantidad: \(parcel.quantity)")
                    .font(.subheadline)
                Text("Peso: \(parcel.weight.formatted()) kg")
                    .font(.subheadline)
            }
        }
    }
}
