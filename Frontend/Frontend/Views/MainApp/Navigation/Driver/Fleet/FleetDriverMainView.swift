//
//  FleetDriverMainView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 24/4/24.
//

import SwiftUI

struct FleetDriverMainView: View {
    
    @EnvironmentObject var fleetDriverModel: FleetDriverViewModel;
    
    var body: some View {
        VStack {
            Text("Hello, Fleet Driver!")
            
            Button(action: {
                if (fleetDriverModel.isUpdatingLocation()) {
                    fleetDriverModel.stopUpdatingLocation();
                } else {
                    fleetDriverModel.startUpdatingLocation();
                }
            }) {
                if (fleetDriverModel.isUpdatingLocation()) {
                    Text("Stop updating location")
                } else {
                    Text("Start updating location")
                }
            }
            .background(fleetDriverModel.isUpdatingLocation() ? Color.red : Color.green)
            .foregroundColor(Color.white)
            .cornerRadius(5)
        }
    }
}

#Preview {
    let authModel = PreviewHelper.authModelFleetDriver;
    let appModel = AppViewModel(authViewModel: authModel);
    let driverModel = DriverViewModel(appModel: appModel);
    
    return FleetDriverMainView()
        .environmentObject(FleetDriverViewModel(driverModel: driverModel))
        .environmentObject(driverModel)
        .environmentObject(authModel)
        .environmentObject(appModel)
}
