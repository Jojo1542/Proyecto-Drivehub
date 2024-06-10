//
//  ContractsSectionView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 17/5/24.
//

import SwiftUI

struct ContractsSectionView: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        Section("Contratos de conductor") {
            ForEach(viewModel.contracts.sorted(by: { $0.startDate > $1.startDate }), id: \.self) { contract in
                HStack {
                    Image(systemName: "doc.text.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding(.trailing, 10)
                    
                    VStack(alignment: .leading) {
                        Text("\(contract.id)")
                            .font(.subheadline)
                            .bold()
                        
                        // Estado
                        Text("Contrato con \(contract.fleet?.name ?? "DriveHub")")
                            .font(.subheadline)
                        
                        Text("Salario: \(contract.salary.formatted()) €")
                            .font(.subheadline)
                        
                        Text("Estado: ")
                            .font(.subheadline)
                        + Text(contract.expired ? "Expirado" : "Activo")
                            .font(.subheadline)
                            .foregroundColor(contract.expired ? .red : .green)
                        
                        HStack {
                            Text(contract.startDate.formatted(date: .abbreviated, time: .omitted))
                                .font(.subheadline)
                            Image(systemName: "arrow.right")
                                .font(.subheadline)
                                .foregroundColor(.accentColor)
                            Text(contract.endDate.formatted(date: .abbreviated, time: .omitted))
                                .font(.subheadline)
                        }
                    }
                }
            }
            
            if viewModel.contracts.isEmpty {
                Text("No tienes ningún contrato aún.")
                    .foregroundColor(.gray)
            }
        }
        .onAppear() {
            viewModel.fetchContracts();
        }
    }
}

#Preview {
    ContractsSectionView()
}
