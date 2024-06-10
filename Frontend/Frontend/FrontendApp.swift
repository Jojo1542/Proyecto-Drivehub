//
//  FrontendApp.x
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 12/4/24.
//

import SwiftUI

@main
struct FrontendApp: App {
    
    @State private var authViewModel = AuthViewModel();
    
    // Test User 1:
    // admin@jojo1542.es
    // KwY3kfF1c5
    
    // Test User 2:
    // migue@prueba.com
    // 1234
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
    }
}
