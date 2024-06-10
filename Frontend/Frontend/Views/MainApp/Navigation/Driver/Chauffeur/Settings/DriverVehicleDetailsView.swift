//
//  DriverVehicleDetailsView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 25/5/24.
//

import SwiftUI

struct DriverVehicleDetailsView: View {
    
    @EnvironmentObject var driverModel: DriverViewModel;
    @State var showingVehicleModificationForm = false;
    
    var body: some View {
        List {
            Section(header: Text("Información del vehículo")) {
                HStack {
                    Text("Matrícula").bold()
                    Spacer();
                    Text(driverModel.user.driverData?.vehiclePlate ?? "No disponible")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Modelo").bold()
                    Spacer();
                    Text(driverModel.user.driverData?.vehicleModel ?? "No disponible")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Color").bold()
                    Spacer();
                    Text(driverModel.user.driverData?.vehicleColor ?? "No disponible")
                        .foregroundColor(.secondary)
                }
            }
            
            // Botón de modificar
            Button(action: {
                self.showingVehicleModificationForm.toggle()
            }, label: {
                HStack {
                    Spacer();
                    Text("Modificar vehículo")
                    Spacer();
                }
            }).sheet(isPresented: $showingVehicleModificationForm) {
                DriverVehicleModificationFormView()
            }
        }
        .navigationTitle("Información del vehículo")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    DriverVehicleDetailsView()
}
