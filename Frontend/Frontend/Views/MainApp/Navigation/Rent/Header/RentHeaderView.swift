//
//  RentHeaderView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 17/5/24.
//

import SwiftUI

struct RentHeaderView: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var rentViewModel: RentViewModel
    
    var rentedCar: UserRentHistoryModel?
    
    var body: some View {
        VStack(alignment: .leading) {
            if rentViewModel.actualRent != nil {
                ActualRentCard(actualUserRent: rentViewModel.actualRent!)
            }
        }
        .onAppear() {
            rentViewModel.updateActualRent()
        }
    }
}

#Preview {
    RentHeaderView()
}
