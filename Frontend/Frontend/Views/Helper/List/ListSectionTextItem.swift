//
//  ListSectionTextItem.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 29/4/24.
//

import SwiftUI

struct ListSectionTextItem: View {
    
    var title: String;
    var description: String;
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(description)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    ListSectionTextItem(
        title: "Nombre",
        description: "Jose Antonio"
    )
}
