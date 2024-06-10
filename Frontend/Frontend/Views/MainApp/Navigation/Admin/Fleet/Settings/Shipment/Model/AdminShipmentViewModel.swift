//
//  AdminShipmentViewModel.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 21/5/24.
//

import Foundation

class AdminShipmentViewModel: ObservableObject {
    
    private var appViewModel: AppViewModel;
    private var fleetId: Int?
    @Published var shipments: [ShipmentModel] = [];
    
    private var sessionToken: String {
        return appViewModel.getSessionToken()
    }
    
    public init(appModel: AppViewModel, fleetId: Int) {
        self.appViewModel = appModel;
        self.fleetId = fleetId;
    }
    
    public func fetchShipments() {
        GetFleetShipmentsRequest.getAllShipment(sessionToken: sessionToken, fleetId: fleetId!) { result in
            switch result {
            case .success(let data):
                self.shipments = data!;
            case .failure(let error):
                print("Fetch fleet shipments failed with error \(error!)")
            }
        }
    }
    
    public func addShipment(data: CreateShipmentRequest.RequestBody, completion: @escaping (Callback<Void, CreateShipmentRequest.ErrorType>) -> Void) {
        CreateShipmentRequest.createShipment(sessionToken: sessionToken, requestBody: data) { result in
            switch result {
            case .success:
                self.fetchShipments() // Refresca los envíos
                completion(.success())
            case .failure(let error):
                completion(.failure(data: error))
            }
        }
    }
    
    public func deleteShipment(shipmentId: Int, completion: @escaping (Callback<Void, Int>) -> Void) {
        DeleteShipmentRequest.deleteShipment(sessionToken: sessionToken, id: shipmentId) { result in
            switch result {
            case .success:
                self.fetchShipments() // Refresca los envíos
                completion(.success())
            case .failure(let error):
                completion(.failure(data: error))
            }
        }
    }
}
