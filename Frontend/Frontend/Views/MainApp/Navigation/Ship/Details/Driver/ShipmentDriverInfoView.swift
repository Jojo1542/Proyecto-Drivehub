//
//  ShipmentDriverInfoView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 20/5/24.
//

import SwiftUI

struct ShipmentDriverInfoView: View {
    
    var driver: ShipmentModel.ShipmentDriver;
    
    var body: some View {
        Section(header: Text("Conductor asignado")) {
            HStack {
                VStack(alignment: .leading) {
                    Text(driver.fullName)
                        .font(.headline)
                    
                    if (driver.phone != nil) {
                        Text("Telefono: \(driver.phone!)")
                            .font(.subheadline)
                        
                    }
                    
                    Text("DNI: \(driver.dni)")
                        .font(.subheadline)
                    Text("Edad: \(driver.age)")
                        .font(.subheadline)
                }
            }
        }
    }
}
