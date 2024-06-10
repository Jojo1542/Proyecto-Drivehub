//
//  AdminContractRow.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 28/5/24.
//

import SwiftUI

struct AdminContractRow: View {
    
    var contract: ContractModel;
    
    var body: some View {
        HStack {
            Image(systemName: "doc.text.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .padding(5)
                .background(Color.accentColor)
                .cornerRadius(10)
                .foregroundColor(.white)
            
            VStack(alignment: .leading) {
                Text("\(contract.id)")
                    .font(.title)
                    .bold()
                
                // Estado
                Text("\(contract.driverData?.fullName ?? "No disponible") - \(contract.driverData?.dni ?? "")")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack {
                    Text(contract.startDate.formatted(date: .abbreviated, time: .omitted))
                    Image(systemName: "arrow.right")
                        .foregroundColor(.accentColor)
                    Text(contract.endDate.formatted(date: .abbreviated, time: .omitted))
                }
            }
        }
    }
}
