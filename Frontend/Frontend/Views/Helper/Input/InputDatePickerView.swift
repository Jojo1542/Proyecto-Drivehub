//
//  InputDatePickerView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 24/4/24.
//

import SwiftUI

struct InputDatePickerView: View {
    
    @Binding var date: Date;
    var icon: String
    var name: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Section {
                HStack {
                    Image(systemName: icon)
                        .frame(width: 20, height: 20)
                    DatePicker(
                        "test",
                        selection: $date,
                        in: ...Date(),
                        displayedComponents: .date
                    )
                    .labelsHidden()
                    .frame(
                        width: UIScreen.main.bounds.width - 80,
                        height: 25,
                        alignment: .center
                    )
                }
                .padding(11)
                .overlay {
                   RoundedRectangle(cornerRadius: 10)
                        .stroke(.secondary, lineWidth: 2)
                 }
                 .padding(.horizontal)
            }
            
            Divider()
        }
    }
}

#Preview {
    InputDatePickerView(date: .constant(Date()), icon: "calendar", name: "Selecciona")
}
