//
//  RentAvailableCarsView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 17/5/24.
//

import SwiftUI

struct RentAvailableCarsView: View {
    
    @EnvironmentObject var rentViewModel: RentViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            if (rentViewModel.actualRent == nil) {
                Text("Coches disponilbes")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
            }
            
            List(rentViewModel.availableVehicles) { car in
                AvaiableCarCard(rentCar: car)
            }
            .refreshable {
                rentViewModel.updateAvailableVehicles()
            }
            .onAppear() {
                rentViewModel.updateAvailableVehicles()
            }
            
        }
    }
}

#Preview {
    RentAvailableCarsView()
}
