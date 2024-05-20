//
//  ChauffeurDriverMainView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 24/4/24.
//

import SwiftUI

struct ChauffeurDriverMainView: View {
    
    @EnvironmentObject var driverModel: DriverViewModel;
    
    var body: some View {
        Text("Hello, Chaffeur!")
    }
}

#Preview {
    let authModel = PreviewHelper.authModelChaoffeur;
    let appModel = AppViewModel(authViewModel: authModel);
    
    return ChauffeurDriverMainView()
        .environmentObject(DriverViewModel(appModel: appModel))
        .environmentObject(authModel)
        .environmentObject(appModel)
}
