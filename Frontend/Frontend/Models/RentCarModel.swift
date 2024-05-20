//
//  RentCarModel.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 15/5/24.
//

import Foundation

struct RentCarModel: Hashable, Decodable, Identifiable {
    
    var id: Int
    var plate: String
    var numBastidor: String
    var brand: String
    var model: String
    var color: String
    var fechaMatriculacion: Date
    var imageUrl: String?
    var precioHora: Double
    
}
