//
//  ActualRentCard.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 16/5/24.
//

import SwiftUI

struct ActualRentCard: View {
    
    @EnvironmentObject var rentViewModel: RentViewModel
    @State private var elapsedTime: TimeInterval = 0
    @State private var showCancelModal = false
    
    var actualUserRent: UserRentHistoryModel;
    
    // Actualizar el contador de segundos cada segundo para mostrar el tiempo transcurrido en tiempo real
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
    
    var actualCar: RentCarModel {
        return actualUserRent.vehicle
    }
    
    var actualUser: UserModel {
        return actualUserRent.user
    }
    
    var timeSpent: String {
        return Duration.seconds(elapsedTime).formatted()
    }
    
    var estimatedPrice: Double {
        let time = Date.now.timeIntervalSince(actualUserRent.startTime)
        return actualCar.precioHora * (time / 3600)
    }
    
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: actualCar.imageUrl!)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Image("placeholder")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .frame(height: 200)
            .cornerRadius(10)
            .clipped()
            
            HStack {
                VStack(alignment: .leading) {
                    Text(actualCar.brand)
                        .font(.title)
                        .fontWeight(.bold)
                    Text(actualCar.model)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                }
                Spacer()
                VStack {
                    Text("Precio estimado")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(estimatedPrice, specifier: "%.2f") €")
                        .font(.title3)
                        .fontWeight(.bold)
                }
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Tiempo transcurrido")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(timeSpent)
                        .font(.title3)
                        .fontWeight(.bold)
                }
                Spacer()
                VStack {
                    Text("Matrícula")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(actualCar.plate)
                        .font(.title3)
                        .fontWeight(.bold)
                }
            }
            
            // Button to end the rent
            Button(action: {
                showCancelModal = true
            }) {
                Text("Finalizar alquiler")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(10)
            }
            .padding(.top)
            .frame(maxWidth: .infinity)
        }
        .onReceive(timer) { _ in
            elapsedTime = Date.now.timeIntervalSince(actualUserRent.startTime);
        }
        .alert(isPresented: $showCancelModal) {
            Alert(
                title: Text("¿Estás seguro de que deseas finalizar el alquiler?"),
                message: Text("Asegurate que has entregado o dejado el vehículo en el lugar correspondiente o se te cobrará una penalización."),
                primaryButton: .default(Text("Cancelar")),
                secondaryButton: .destructive(Text("Finalizar"), action: {
                    withAnimation(.easeInOut) {
                        processEndRent()
                    }
                })
            )
        }
    }
    
    func processEndRent() {
        rentViewModel.returnVehicle(vehicleId: actualCar.id) { result in
            switch result {
            case .success(_):
                showDialog(title: "Éxito", description: String(localized: "El vehículo ha sido devuelto con éxito."))
            case .failure(let error):
                switch error {
                case .USER_DOES_NOT_HAVE_ACTIVE_RENT:
                    showDialog(title: "Error", description: String(localized: "No tienes ningún alquiler activo."))
                    break;
                case .VEHICLE_NOT_FOUND:
                    showDialog(title: "Error", description: String(localized: "El vehículo no ha sido encontrado."))
                    break;
                case .VEHICLE_NOT_RENTED_BY_USER:
                    showDialog(title: "Error", description: String(localized: "El vehículo no está alquilado."))
                    break;
                default:
                    showDialog(title: "Error", description: String(localized: "Ha ocurrido un error desconocido."))
                    break;
                }
            }
        }
    }
}

#Preview {
    ActualRentCard(actualUserRent: PreviewHelper.activeUserRentHistoryModel)
}
