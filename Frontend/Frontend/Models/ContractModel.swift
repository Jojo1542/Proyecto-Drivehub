//
//  ContractModel.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 15/5/24.
//

import Foundation

class ContractModel: Hashable, Decodable, Identifiable {
    
    var id: Int64
    var startDate: Date
    var endDate: Date
    var salary: Double
    var nextContract: ContractModel?
    var previousContract: ContractModel?
    var fleet: FleetModel?
    var driver: Int64
    
    /*
     Metodos necesarios al tener una clase y no una estructura de datos
     */
    
    static func ==(lhs: ContractModel, rhs: ContractModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
}
