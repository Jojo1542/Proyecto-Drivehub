//
//  ShipmentDataView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 19/5/24.
//

import SwiftUI
import CoreLocation

struct ShipmentDataView: View {
    
    var shipment: ShipmentModel;
    @State var currentLocation: CLLocation? = CLLocation(
        latitude: 37.372691101262745, longitude: -5.931555549354958
    );
    
    var body: some View {
        if (currentLocation != nil) {
            Section(header: Text("Localización")) {
                ShipmentMapView(shipment: shipment, currentLocation: currentLocation!)
                    .frame(height: 200)
            }
            .listRowInsets(EdgeInsets())
        }
        
        Section(header: Text("Dirección de envio")) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Origen")
                        .font(.headline)
                    Text(shipment.sourceAddress)
                        .font(.subheadline)
                }
                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .foregroundColor(.gray)
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Destino")
                        .font(.headline)
                    Text(shipment.destinationAddress)
                        .font(.subheadline)
                }
            }
            .padding()
        }
        
        Section(header: Text("Datos del envío")) {
            HStack {
                Text("Estado")
                    .font(.headline)
                Spacer()
                Text(shipment.actualStatus.userFriendlyName)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(Color.accentColor)
            }
            
            HStack {
                Text("Fecha de salida")
                    .font(.headline)
                Spacer()
                Text(shipment.shipmentDate, style: .date)
                    .font(.subheadline)
            }
            
            HStack {
                Text("Fecha de llegada")
                    .font(.headline)
                Spacer()
                Text(shipment.shipmentDate, style: .date)
                    .font(.subheadline)
            }
        }
    }
}

#Preview {
    ShipmentDataView(shipment: PreviewHelper.exampleShipment)
}
