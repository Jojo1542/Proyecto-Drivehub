//
//  ShipmentViewModel.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 22/5/24.
//

import Foundation

class ShipmentViewModel: ObservableObject {
    
    private var appViewModel: AppViewModel;
    
    init(appViewModel: AppViewModel) {
        self.appViewModel = appViewModel
    }
    
    func findShipment(shipmentId: Int, completion: @escaping (Callback<ShipmentModel, Int>) -> Void) {
        GetShipmentDetailsRequest.getShipmentDetails(sessionToken: appViewModel.getSessionToken(), id: shipmentId) { result in
            switch result {
                case .success(let data):
                    completion(.success(data: data!))
                case .failure(let error):
                    completion(.failure(data: error))
            }
        }
    }
    
}
