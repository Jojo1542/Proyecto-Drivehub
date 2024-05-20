//
//  DocumentsView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 17/5/24.
//

import SwiftUI

struct DocumentsView: View {
    var body: some View {
        List {
            LicensesSectionView()
            ContractsSectionView()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Mis documentos")
    }
}

#Preview {
    DocumentsView()
        .environmentObject(PreviewHelper.authModelUser)
        .environmentObject(AppViewModel(authViewModel: PreviewHelper.authModelUser))
}
