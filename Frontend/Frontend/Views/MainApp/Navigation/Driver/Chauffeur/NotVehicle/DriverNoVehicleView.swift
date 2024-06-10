//
//  DriverNoVehicleView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 25/5/24.
//

import SwiftUI

struct DriverNoVehicleView: View {
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text("No has especificado un vehículo")
                    .bold()
                    .font(.title)
                    .padding(.top, 20)
                
                Text("Para comenzar a conducir, añade un vehículo a tu perfil, por favor.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 10)
            }
            .padding(.horizontal)
            
            DriverVehicleModificationFormView()
        }
    }
}
