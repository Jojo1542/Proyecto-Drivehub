//
//  ShipmentMapView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 19/5/24.
//

import SwiftUI
import CoreLocation

struct ShipmentMapView: View {

    var shipment: ShipmentModel;
    var currentLocation: CLLocation;
    
    @State private var destinationLocation: CLLocation?;
    @State private var sourceLocation: CLLocation?;

    var body: some View {
        VStack {
            if (destinationLocation != nil && sourceLocation != nil) {
                MapIndicationsView(
                    estimatedTime: .constant(0),
                    estimatedDistance: .constant(0),
                    sourceCoordinate: CLLocationCoordinate2D(
                        latitude: sourceLocation!.coordinate.latitude,
                        longitude: sourceLocation!.coordinate.longitude
                    ),
                    destinationCoordinate: CLLocationCoordinate2D(
                        latitude: destinationLocation!.coordinate.latitude,
                        longitude: destinationLocation!.coordinate.longitude
                    ),
                    customMarkers: [
                        CustomMapMarker(
                            coordinate: CLLocationCoordinate2D(
                                latitude: currentLocation.coordinate.latitude,
                                longitude: currentLocation.coordinate.longitude
                            ),
                            title: "Ubicación del paquete",
                            icon: "shippingbox.fill"
                        )
                    ]
                )
            } else {
                ProgressView()
            }
        }.onAppear() {
            lookUpAddress(address: shipment.sourceAddress) { placemark in
                if let placemark = placemark {
                    sourceLocation = placemark.location
                }
            }
            
            lookUpAddress(address: shipment.destinationAddress) { placemark in
                if let placemark = placemark {
                    destinationLocation = placemark.location
                }
            }
        }
    }
}

#Preview {
    ShipmentMapView(
        shipment: PreviewHelper.exampleShipment,
        currentLocation: CLLocation(latitude: 0, longitude: 0)
    )
}
