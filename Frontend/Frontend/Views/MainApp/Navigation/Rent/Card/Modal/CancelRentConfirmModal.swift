//
//  CancelRentConfirmModal.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 17/5/24.
//

import SwiftUI

struct CancelRentConfirmModal: View {
    
    @Binding var showModal: Bool
    var onConfirm: () -> Void
    
    var body: some View {
            VStack {
                Text("¿Estás seguro de que deseas finalizar el alquiler?")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()
                
                HStack {
                    Button("Cancelar") {
                        showModal = false
                    }
                    .padding()
                    
                    Button("Confirmar") {
                        onConfirm()
                        showModal = false
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(10)
                }
            }
            .padding()
        }
}
