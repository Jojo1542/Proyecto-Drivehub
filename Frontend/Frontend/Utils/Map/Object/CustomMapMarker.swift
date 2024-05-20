//
//  CustomMapMarker.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 19/5/24.
//

import Foundation
import CoreLocation

struct CustomMapMarker: Identifiable {
    var id = UUID()
    var coordinate: CLLocationCoordinate2D
    var title: String
    var icon: String
}
