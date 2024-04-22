//
//  ContentView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 12/4/24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel;
    
    var body: some View {
        Group {
            if (authViewModel.sessionToken != nil) {
                MainAppView()
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
