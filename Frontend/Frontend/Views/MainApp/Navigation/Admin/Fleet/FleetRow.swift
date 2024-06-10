//
//  FleetRow.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 21/5/24.
//

import SwiftUI

struct FleetRow: View {
    
    var fleet: FleetModel;
    
    var body: some View {
        HStack {
            Image(systemName: "shippingbox.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .padding(.trailing, 10)
                .foregroundColor(.blue)
            VStack(alignment: .leading) {
                Text(fleet.name)
                    .font(.title2)
                    .fontWeight(.bold)
                Text(fleet.cif)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(fleet.vehicleType.name)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}
