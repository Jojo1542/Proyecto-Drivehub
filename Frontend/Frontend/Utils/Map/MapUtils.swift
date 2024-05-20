//
//  MapUtils.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 29/4/24.
//

import Foundation
import CoreLocation
import SwiftUI

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
 Abre google maps con la navegación a un destino
 */
func openGoogleMapsNavigation(destinationCoordinate: CLLocationCoordinate2D) {
    let urlString = "comgooglemaps://?daddr=\(destinationCoordinate.latitude),\(destinationCoordinate.longitude)&directionsmode=driving"
    if let url = URL(string: urlString) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
