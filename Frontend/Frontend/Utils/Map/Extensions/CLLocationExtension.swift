//
//  CLLocationExtension.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 28/5/24.
//

import CoreLocation

extension CLLocationDistance {
    
    /*
     Añade el metodo formattedKilometers() a CLLocationDistance para obtener los KM de forma más comoda
     */
    
    func formattedKilometers() -> String {
        let kilometers = self / 1000
        return String(format: "%.2f km", kilometers)
    }
}
