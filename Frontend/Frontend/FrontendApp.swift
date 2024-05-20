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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
    }
}
