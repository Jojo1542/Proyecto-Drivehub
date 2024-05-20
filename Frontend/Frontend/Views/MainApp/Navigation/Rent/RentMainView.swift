//
//  RentMainView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 16/5/24.
//

import SwiftUI

struct RentMainView: View {
    
    @EnvironmentObject private var rentModel: RentViewModel
    
    var body: some View {
        VStack {
            RentHeaderView()
            RentAvailableCarsView()
        }
    }
}

#Preview {
    RentMainView()
        .environmentObject(RentViewModel(appViewModel: AppViewModel(authViewModel: PreviewHelper.authModelUser)))
}
