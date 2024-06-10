//
//  BalanceModificationFormView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 30/5/24.
//

import SwiftUI

struct BalanceModificationFormView: View {
    
    @EnvironmentObject var viewModel: AdminUserViewModel;
    @Environment(\.presentationMode) var presentationMode;
    @Binding var user: UserModel;
    
    @State var amount: Double = 0.0;
    @State var action: UserModel.BalanceHistory.MovementType = .DEPOSIT
    
    var body: some View {
        Form {
            Section {
                LabeledContent("Cantidad") {
                    TextField("Cantidad", value: $amount, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                }
                
                Picker("Acción", selection: $action) {
                    ForEach(UserModel.BalanceHistory.MovementType.allCases, id: \.self) { action in
                        Text(action.rawValue)
                    }
                }
            }
            
            Section {
                Button(action: {
                    withAnimation(.bouncy) {
                        processSaving()
                    }
                }, label: {
                    Label("Guardar", systemImage: "checkmark")
                })
            }
            
        }
    }
    
    func processSaving() {
        viewModel.updateBalance(userId: user.id, data: UserUpdateBalanceRequest.RequestBody(amount: amount, type: action)) { result in
            switch result {
                case .success:
                    showDialog(title: "Éxito", description: "El saldo del usuario ha sido actualizado correctamente")
                
                    // Cambiar el saldo del usuario y crear un registro en el historial
                    user.balance += action == .DEPOSIT ? amount : -amount;
                    user.balanceHistory?.append(UserModel.BalanceHistory(id: 0, type: action, amount: amount, date: Date.now))
                
                    // Cerrar la pantalla
                    self.presentationMode.wrappedValue.dismiss();
                case let .failure(error):
                    showDialog(title: "Error", description: "No se ha podido actualizar el saldo del usuario")
                    print("Balance update failed with error \(error ?? 0)")
            }
        }
    }
}
