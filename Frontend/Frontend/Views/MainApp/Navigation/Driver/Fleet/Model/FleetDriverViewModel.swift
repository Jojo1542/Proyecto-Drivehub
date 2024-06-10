//
//  FleetDriverViewModel.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 19/5/24.
//

import Foundation

class FleetDriverViewModel: ObservableObject {
    
    private var driverModel: DriverViewModel;
    
    @Published var fleet: FleetModel?;
    @Published var shipments: [ShipmentModel] = [];
    
    init(driverModel: DriverViewModel) {
        self.driverModel = driverModel;
    }
    
    var user: UserModel {
        return self.driverModel.user;
    }
    
    var driverData: UserModel.DriverData {
        return self.driverModel.driverData;
    }
    
    func startUpdatingLocation() {
        self.driverModel.startUpdatingLocation();
    }
    
    func stopUpdatingLocation() {
        self.driverModel.stopUpdatingLocation();
    }
    
    func isUpdatingLocation() -> Bool {
        return self.driverModel.isUpdatingLocation();
    }
    
    func fetchShipments() {
        GetAssignedShipmentRequest.getAssignedShipments(sessionToken: driverModel.sessionToken) { result in
            switch result {
                case .success(let data):
                    self.shipments = data!;
                case .failure(let error):
                    print("Fetch driver shipments failed with error \(error!)")
            }
        }
    }
    
    func fetchFleet() {
        GetOwnFleetRequest.getOwnFleet(sessionToken: driverModel.sessionToken) { result in
            switch result {
                case .success(let data):
                    self.fleet = data!;
                case .failure(let error):
                    print("Fetch driver fleet failed with error \(error!)")
            }
        }
    }
    
    func updateShipmentStatus(shipmentId: Int, newStatus: UpdateShipmentStatusRequest.RequestBody, completion: @escaping (Callback<Void, Int>) -> Void) {
        UpdateShipmentStatusRequest.updateShipmentStatus(sessionToken: driverModel.sessionToken, id: shipmentId, requestBody: newStatus) { result in
            switch result {
                case .success:
                    self.fetchShipments() // Refresca los envíos
                    completion(.success());
                case .failure(let error):
                    print("Update shipment status failed with error \(error!)")
                    completion(.failure(data: error!));
            }
        }
    }
    
    func updatePersonalData(avaiableTime: String, maxTonnage: Double, completion: @escaping (Callback<Void, Int>) -> Void) {
        driverModel.updateDriver(data: UserUpdateDriverRequest.RequestBody(
            avaiableTime: avaiableTime,
            maxTonnage: maxTonnage
        ), completion: completion)
    }
    
}
