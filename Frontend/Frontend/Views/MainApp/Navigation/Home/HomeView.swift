//
//  HomeView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 16/4/24.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        VStack {
            MapView(followUser: true)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(PreviewHelper.authModelUser)
}
