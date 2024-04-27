//
//  ListHeader.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 25/4/24.
//

import SwiftUI

struct ListSectionHeader: View {
    
    var title: String;
    var icon: String;
    
    var body: some View {
        Label(title, systemImage: icon)
            .font(.callout)
    }
}

#Preview {
    Group {
        List {
            Section(header: ListSectionHeader(title: "Información", icon: "info.circle.fill")) {
                Text("Hola mundo")
                Toggle("Test", isOn: .constant(true))
            }
            
            Section(header: ListSectionHeader(title: "Información", icon: "info.circle.fill")) {
                Text("Hola mundo")
                Toggle("Test", isOn: .constant(true))
            }
        }
    }
}
