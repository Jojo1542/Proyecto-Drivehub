//
//  TripDriverCard.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 29/5/24.
//

import SwiftUI

struct TripDriverCard: View {
    
    var driver: TripModel.DriverInfo;
    
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
                Text(driver.fullName)
                    .font(.title)
                    .bold()
                
                // Edad
                Text("\(driver.calculateYears()) años")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                // DNI
                Text(driver.dni)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
                
        }
    }
}
