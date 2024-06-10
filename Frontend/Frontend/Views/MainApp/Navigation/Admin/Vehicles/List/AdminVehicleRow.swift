//
//  AdminVehicleRow.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 21/5/24.
//

import SwiftUI

struct AdminVehicleRow: View {
    
    var vehicle: RentCarModel;
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(vehicle.brand)
                    .font(.title)
                    .fontWeight(.bold)
                Text(vehicle.model)
                    .font(.title2)
                    .fontWeight(.medium)
            }
            Spacer()
            VStack {
                Text(vehicle.plate)
                    .font(.title2)
                    .fontWeight(.medium)
            }
        }
    }
}
