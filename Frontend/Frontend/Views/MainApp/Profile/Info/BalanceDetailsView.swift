//
//  BalanceDetailsView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 29/4/24.
//

import SwiftUI

struct BalanceDetailsView: View {
    
    @EnvironmentObject var appModel: AppViewModel;
    var formatter = RelativeDateTimeFormatter();
    
    var body: some View {
        VStack(alignment: .leading){
            // Ver tu saldo
            HStack {
                Text("Saldo actual")
                    .font(.title2)
                    .bold()
                Spacer()
                Text("\(appModel.getUser().saldo.formatted()) €")
                    .font(.title2)
                    .bold()
            }
            .padding(.horizontal)
            
            // Lista de movimientos
            List {
                Section(header: Text("Últimos movimientos").font(.title3).bold()) {
                    ForEach(appModel.getUser().balanceHistory ?? [], id: \.id) { movimiento in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(movimiento.type == .DEPOSIT ? "Ingreso" : "Gasto")
                                    .font(.title3)
                                
                                // Relative time
                                Text(formatter.localizedString(for: movimiento.date, relativeTo: Date()))
                                    .font(.subheadline)
                                
                            }
                            Spacer()
                            Text("\(movimiento.type == .DEPOSIT ? "+" : "-")\(movimiento.amount.formatted()) €")
                                .font(.title3)
                        }
                    }
                    
                    if appModel.getUser().balanceHistory == nil {
                        Text("No hay movimientos")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
        }
    
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Saldo")
    }
}

#Preview {
    BalanceDetailsView()
        .environmentObject(PreviewHelper.authModelUser)
        .environmentObject(AppViewModel(authViewModel: PreviewHelper.authModelUser))
}
