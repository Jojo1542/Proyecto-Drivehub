//
//  InputFieldView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 12/4/24.
//

import SwiftUI

struct InputFieldView: View {
    
    @Binding var text: String;
    var icon: String
    var placeholder: String;
    var isPassword = false;
    var validator: ((Bool) -> Void) = { _ in };
    var type: UITextContentType? = .none;
    var keyboard: UIKeyboardType = .default;
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Section {
                HStack {
                    Image(systemName: icon)
                        .frame(width: 20, height: 20)
                    if isPassword {
                        SecureField(placeholder, text: $text)
                            .font(.system(size: 18))
                            .textContentType(.password)
                    } else {
                        TextField(placeholder, text: $text, onEditingChanged: validator)
                            .font(.system(size: 18))
                            // Ajustes del teclado
                            .autocorrectionDisabled(false)
                            .disableAutocorrection(true)
                            .textContentType(type)
                            .keyboardType(keyboard)
                            .textInputAutocapitalization((type == .emailAddress) ? .none : .sentences)
                    }
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
    InputFieldView(text: .constant(""), icon: "envelope.fill", placeholder: "hello@example.com")
}

#Preview("Group") {
    Group {
        InputFieldView(text: .constant(""), icon: "envelope.fill", placeholder: "hello@example.com")
        InputFieldView(text: .constant(""), icon: "key.fill", placeholder: "password", isPassword: true)
    }
}
