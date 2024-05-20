//
//  IconUtils.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 17/5/24.
//

import Foundation

func getIconFromLicenseType(type: UserModel.DriverLicense.DriverLicenseType) -> String {
    switch type {
        case .A, .A2, .A1:
            return "bicycle"
        case .B, .BE:
            return "car.rear"
        case .C, .C1:
            return "truck"
        default:
            return "camera.metering.unknown"
    }
}
