//
//  MapIndicationsView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 29/4/24.
//

import SwiftUI
import CoreLocation
import MapKit

struct MapIndicationsView: View {
    
    @State private var route: MKRoute?;
    
    // Variables que se actualizan al calcular la ruta
    @Binding var estimatedTime: TimeInterval?;
    @Binding var estimatedDistance: CLLocationDistance?;
    
    var sourceCoordinate: CLLocationCoordinate2D;
    var destinationCoordinate: CLLocationCoordinate2D;
    var customMarkers: [CustomMapMarker]? = [];
    var overlay: AnyView? = nil;
    
    var body: some View {
        Map() {
            Marker("Salida", systemImage: "", coordinate: sourceCoordinate)
            Marker("Destino", systemImage: "", coordinate: destinationCoordinate)
            
            // Mostrar la ruta calculada (Controla que ruta no sea nula con el let)
            if let route {
                MapPolyline(route)
                    .stroke(Color.accentColor, lineWidth: 5)
            }
            
            // Parcel location marker
            if let customMarkers {
                ForEach(customMarkers) { marker in
                    Marker(marker.title, systemImage: marker.icon, coordinate: marker.coordinate)
                }
            }
        }.onAppear {
            // Calcular la ruta cuando se muestre el mapa
            getRoute();
        }.safeAreaInset(edge: .bottom) {
            if overlay != nil {
                overlay
            }
        }
    }
    
    private func getRoute() {
        // Crear una solicitud de ruta
        let request = MKDirections.Request();
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: sourceCoordinate)); // La salida es el Origen
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate)); // La llegada el destino
        request.requestsAlternateRoutes = false; // No mostrar rutas alternativas, solamente la recomendada.
        request.transportType = .automobile; // El viaje es el coche
        
        // Hacer crear la solicitud de direcciones
        let directions = MKDirections(request: request);
        // Calcular la ruta final
        directions.calculate { response, error in
            // Controlar que la ruta no sea nula, con una clausula de guarda
            guard let route = response?.routes.first else {
                return;
            }
            
            // Actualizar la ruta en la vista
            self.route = route;
            
            // Actualizar el tiempo estimado
            self.estimatedTime = route.expectedTravelTime;
            
            // Actualizar la distancia estimada
            self.estimatedDistance = route.distance;
        }
    }
}

#Preview("Madrid - Sevilla") {
    MapIndicationsView(
        estimatedTime: .constant(0),
        estimatedDistance: .constant(0),
        sourceCoordinate: CLLocationCoordinate2D(latitude: 37.388630, longitude: -5.982430),
        destinationCoordinate: CLLocationCoordinate2D(latitude: 40.416775, longitude: -3.703790)
    )
}

#Preview("Madrid - Barcelona") {
    MapIndicationsView(
        estimatedTime: .constant(0),
        estimatedDistance: .constant(0),
        sourceCoordinate: CLLocationCoordinate2D(latitude: 40.416775, longitude: -3.703790),
        destinationCoordinate: CLLocationCoordinate2D(latitude: 41.385063, longitude: 2.173404)
    )
}

#Preview("Palmete - Instituto") {
    MapIndicationsView(
        estimatedTime: .constant(0),
        estimatedDistance: .constant(0),
        sourceCoordinate: CLLocationCoordinate2D(latitude: 37.373469, longitude: -5.930973),
        destinationCoordinate: CLLocationCoordinate2D(latitude: 37.375939, longitude: -5.967745)
    )
}
