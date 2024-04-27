//
//  MapView.swift
//  Marcadores
//
//  Created by Jose Antonio Ponce Piñero on 26/2/24.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    // Coordenadas dinamicas
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.334_900, longitude: -122.009_020)
    var followUser: Bool = false
    var locationManager = CLLocationManager()
    
    var body: some View {
        // Se coloca un mapa en pantalla con la posición inicial
        // en las coordenadas de la variable de abajo, en esta se define el
        // las coordenadas y el zoom
        
        //Map(initialPosition: .region(region))
        // Se coloca constante para evitar tener en cuenta si alguien mueve el mapa interactuando con este
        //Map(position: .constant(.region(region)))
        if (followUser) {
            Map(
                coordinateRegion: .constant(region),
                showsUserLocation: true,
                userTrackingMode: .constant(.follow)
            ).onAppear {
                locationManager.requestWhenInUseAuthorization()
            }
        } else {
            Map(
                coordinateRegion: .constant(region),
                showsUserLocation: true
            ).onAppear {
                locationManager.requestWhenInUseAuthorization()
            }
        }
    }
    
    /*
     Variable que se genera con un constructor, es como las variables de C# con el get{} y set{}
     */
    private var region: MKCoordinateRegion {
        // Se construye el objeto que creo que es la localización y el zoom al mapa
        // Posición de la camara en el mapa
        MKCoordinateRegion(
            // https://developer.apple.com/documentation/corelocation/cllocationcoordinate2d
            // LatLon de android
            center: coordinate,
            // https://developer.apple.com/documentation/mapkit/mkcoordinatespan
            // Zoom deseadi
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
    }
}

#Preview {
    // https://developer.apple.com/documentation/corelocation/cllocationcoordinate2d
    // LatLon de android
    MapView(coordinate: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868))
}
