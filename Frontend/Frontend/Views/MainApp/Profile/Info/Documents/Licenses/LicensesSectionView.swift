//
//  LicensesSectionView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 17/5/24.
//

import SwiftUI

struct LicensesSectionView: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    @State var driverLicenses: [UserModel.DriverLicense] = []
    
    var body: some View {
        Section("Permisos de conducir") {
            // Button to add a new driver license
            NavigationLink(destination: AddDriverLicenseView(driverLicenses: $driverLicenses)) {
                HStack {
                    Image(systemName: "plus.circle")
                    Text("Añadir permiso de conducir")
                }
                .foregroundColor(.accentColor)
            }
            
            ForEach(driverLicenses, id: \.self) { driverLicense in
                DriverLicenseCard(driverLicense: driverLicense)
            }
        }
        .onAppear() {
            driverLicenses = appViewModel.getUser().driverLicenses;
        }
    }
}

#Preview {
    LicensesSectionView()
        .environmentObject(PreviewHelper.authModelUser)
        .environmentObject(AppViewModel(authViewModel: PreviewHelper.authModelUser))
}
