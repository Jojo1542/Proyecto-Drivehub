//
//  AdminFleetDriverRow.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 22/5/24.
//

import SwiftUI

struct UserRow: View {
    
    var user: UserModel;
    
    var body: some View {
        HStack {
            Image(systemName: "person.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .padding(5)
                .background(Color.accentColor)
                .cornerRadius(10)
                .foregroundColor(.white)
            
            VStack(alignment: .leading) {
                Text("\(user.firstName) \(user.lastName)")
                    .font(.title)
                    .bold()
                
                // Email
                Text(user.email)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                // DNI
                Text(user.dni ?? "No tiene DNI")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
                
        }
    }
}

#Preview {
    UserRow(user: PreviewHelper.authModelFleetDriver.currentUser!)
}
