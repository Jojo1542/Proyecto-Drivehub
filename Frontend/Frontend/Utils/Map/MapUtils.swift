//
//  MapUtils.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 29/4/24.
//

import Foundation
import CoreLocation
import SwiftUI
import MapKit

/*
 Abre apple maps con la navegación a un destino
 */
func openAppleMapsNavigation(destinationCoordinate: CLLocationCoordinate2D) {
    let urlString = "http://maps.apple.com/?daddr=\(destinationCoordinate.latitude),\(destinationCoordinate.longitude)&dirflg=d"
    if let url = URL(string: urlString) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

/*
 Abre google maps con la navegación a un destino, o la App Store si no está instalado
 */
func openGoogleMapsNavigation(destinationCoordinate: CLLocationCoordinate2D) {
    let urlString = "comgooglemaps://?daddr=\(destinationCoordinate.latitude),\(destinationCoordinate.longitude)&directionsmode=driving"
    if let url = URL(string: urlString) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            // Si Google Maps no está instalado, abrir la App Store para descargarla
            let appStoreURL = URL(string: "https://apps.apple.com/app/google-maps/id585027354")!
            UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
        }
    }
}

/*
 Abre Waze con la navegación a un destino
 */
func openWazeNavigation(destinationCoordinate: CLLocationCoordinate2D) {
    let urlString = "waze://?ll=\(destinationCoordinate.latitude),\(destinationCoordinate.longitude)&navigate=yes"
    if let url = URL(string: urlString) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            // Si Waze no está instalado, abrir la App Store para descargarla
            let appStoreURL = URL(string: "https://apps.apple.com/app/waze-navigation-live-traffic/id323229106")!
            UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
        }
    }
}

func lookUpCurrentLocation(coordinates: CLLocation, completionHandler: @escaping (CLPlacemark?) -> Void ) {
    // Obtiene el geoencoder
    let geocoder = CLGeocoder()
        
    // Comprueba las coordenadas de la localización
    geocoder.reverseGeocodeLocation(coordinates, completionHandler: { (placemarks, error) in
        if (error == nil) {
            let firstLocation = placemarks?[0]
            completionHandler(firstLocation)
        } else {
            completionHandler(nil)
        }
    })
}

func lookUpCurrentLocation(coordinates: CLLocationCoordinate2D, completionHandler: @escaping (CLPlacemark?) -> Void ) {
    lookUpCurrentLocation(coordinates: CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude), completionHandler: completionHandler)
}

func lookUpAddress(address: String, completionHandler: @escaping (CLPlacemark?) -> Void ) {
    // Obtiene el geoencoder
    let geocoder = CLGeocoder()
        
    // Comprueba las coordenadas de la localización
    geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
        if (error == nil) {
            let firstLocation = placemarks?[0]
            completionHandler(firstLocation)
        } else {
            completionHandler(nil)
        }
    })
}

/*func lookUpAllResultsForAddress(address: String, completionHandler: @escaping ([CLPlacemark]?) -> Void ) {
    // Obtiene el geoencoder
    let geocoder = CLGeocoder()
        
    // Comprueba las coordenadas de la localización
    geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
        if (error == nil) {
            completionHandler(placemarks)
        } else {
            completionHandler(nil)
        }
    })
}*/

func lookUpAllResultsForAddress(address: String, completionHandler: @escaping ([CLPlacemark]?) -> Void) {
    // Obtiene la api de MapKit
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = address // Especifica que se va a usar la dirección para buscar
    
    // Realizar la busqueda
    let search = MKLocalSearch(request: request)
    search.start { response, error in
        if (error == nil) {
            // Convertir los resultados en un array de placemarks
            let placemarks = response?.mapItems.map { $0.placemark }
            
            completionHandler(placemarks)
        } else {
            completionHandler(nil)
        }
    }
}

func formattedAddress(from placemark: CLPlacemark) -> String {
    var addressString = ""
    
    if let name = placemark.name {
        addressString += name + ", "
    }
    
    if let thoroughfare = placemark.thoroughfare {
        var subAddressString = thoroughfare
        
        if let subThoroughfare = placemark.subThoroughfare {
            subAddressString += ", " + subThoroughfare
        }
        
        // Para sitios como tiendas, se coloca la dirección de la tienda y no el nombre
        if !addressString.starts(with: subAddressString) {
            addressString = subAddressString + ", "
        }
    }
    
    if let locality = placemark.locality {
        addressString += locality + ", "
    }
    
    if let postalCode = placemark.postalCode {
        addressString += postalCode
    }
    
    // Remove the trailing comma and space if there is one
    if addressString.hasSuffix(", ") {
        addressString = String(addressString.dropLast(2))
    }
    
    return addressString
}

func calculateRoute(sourceCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D, completionHandler: @escaping (MKRoute?) -> Void) {
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
            completionHandler(nil);
            return;
        }
        
        // Actualizar la ruta en la vista
        completionHandler(route);
    }
}
