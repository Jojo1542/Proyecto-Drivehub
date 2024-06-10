//
//  TripsSearchView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 23/5/24.
//

import SwiftUI

struct TripsSearchView: View {
    var body: some View {
        ZStack {
            MapView(followUser: true)
            MenuSheetView()
        }
    }
}

#Preview {
    TripsSearchView()
        .environmentObject(PreviewHelper.authModelUser)
}
