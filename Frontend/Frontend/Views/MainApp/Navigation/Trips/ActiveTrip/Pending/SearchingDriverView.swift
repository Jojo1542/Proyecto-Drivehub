//
//  SearchingDriverView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 23/5/24.
//

import SwiftUI
import Lottie

struct SearchingDriverView: View {
    
    @EnvironmentObject var viewModel: TripsViewModel;
    
    // 1 second timer
    let timer = Timer.publish(every: 0.7, on: .main, in: .common).autoconnect()
    @State var dotCount = 3
    @State var animation = "";
    
    @State private var showCancelModal = false;
    
    var body: some View {
        VStack {
            // Searching for driver
            Text("Buscando conductor" + String(repeating: ".", count: dotCount))
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 20)
            
            // Lottie Animation
            LottieView(animation: .named(animation))
              .looping()
              .frame(width: UIScreen.main.bounds.width, height: 300)
              .padding(.vertical, 20)
            
            // Button to cancel
            Button(action: {
                showCancelModal.toggle()
            }) {
                Text("Cancelar")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 30)
                    .background(Color.red)
                    .cornerRadius(15)
            }
        }.onReceive(timer) { _ in
            // Actualizar la cantidad de puntos del texto
            if dotCount == 3 {
                dotCount = 0
            } else {
                dotCount += 1
            }
        }.onAppear() {
            animation = ["Car3D", "CarPacman"].randomElement()!
        }.alert(isPresented: $showCancelModal) {
            Alert(
                title: Text("¿Estás seguro de cancelar el viaje?"),
                message: Text("Si cancelas el viaje ahora, no se te cobrará una penalización."),
                primaryButton: .default(Text("Cancelar")),
                secondaryButton: .destructive(Text("Finalizar"), action: {
                    withAnimation(.easeInOut) {
                        processCancel()
                    }
                })
            )
        }
    }
    
    func processCancel() {
        viewModel.cancelTrip { result in
            switch result {
            case .success(_):
                showDialog(title: "Viaje cancelado", description: "El viaje ha sido cancelado.")
            case .failure(_):
                showDialog(title: "Error", description: "No se pudo cancelar el viaje, intenta de nuevo.");
            }
        }
    }
}

#Preview {
    SearchingDriverView()
}
