//
//  AdminTripViewModel.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 30/5/24.
//

import Foundation

class AdminTripViewModel: ObservableObject {
    private var appViewModel: AppViewModel;
    
    @Published var trips: [TripModel] = []
    
    init (appModel: AppViewModel) {
        self.appViewModel = appModel;
    }
    
    public func fetchTrips() {
        GetAllTripsRequest.getTrips(sessionToken: appViewModel.getSessionToken()) { result in
            switch result {
            case .success(let data):
                self.trips = data!;
            case .failure(let error):
                print("Fetch trips failed with error \(error!)")
            }
        }
    }
    
    public func fetchActiveTrips() {
        GetAllActiveTripsRequest.getTrips(sessionToken: appViewModel.getSessionToken()) { result in
            switch result {
            case .success(let data):
                self.trips = data!;
            case .failure(let error):
                print("Fetch active trips failed with error \(error!)")
            }
        }
    }
    
}
