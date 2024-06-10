//
//  AvaiableCarCard.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 16/5/24.
//

import SwiftUI

struct AvaiableCarCard: View {
    
    @EnvironmentObject var rentViewModel: RentViewModel;
    @State private var showConfirmModal = false
    var rentCar: RentCarModel;
    
    var body: some View {
        HStack {
            AsyncImage(
                url: URL(string: rentCar.imageUrl!),
                content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: 300, maxHeight: 100)
                },
                placeholder: {
                    ProgressView()
            })
            .frame(width: 115, height: 95)
            .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text("\(rentCar.brand) \(rentCar.model)")
                    .font(.title2)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading) {
                    Text("Matrícula: \(rentCar.plate)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Color: \(rentCar.color)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Precio/H: \(rentCar.precioHora, specifier: "%.2f") €")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.leading, 5)
            }
            
            Spacer()
            
            // Mostrar el botón de alquilar solo si no hay un coche alquilado
            if rentViewModel.actualRent == nil {
                VStack {
                    Button(action: {
                        withAnimation {
                            showConfirmModal.toggle()
                        }
                    }) {
                        Image(systemName: "cart")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    // Fondo cuadrado
                    .frame(width: 50, height: 50)
                    .background(Color.accentColor)
                    .cornerRadius(10)
                    .padding(.bottom, 5)
                    .alert(isPresented: $showConfirmModal) {
                        Alert(
                            title: Text("¿Estás seguro?"),
                            message: Text("¿Quieres alquilar el vehiculo \(rentCar.brand) \(rentCar.model) por \(rentCar.precioHora, specifier: "%.2f") €/hora? Recuerda que las horas se cobran completas. Incluso si solo alquilas 1 minuto, se cobrará 1 hora completa."),
                            primaryButton: .default(Text("Sí")) {
                                processRentCar()
                            },
                            secondaryButton: .cancel(Text("No"))
                        )
                    }
                }
            }
        }
    }
    
    func processRentCar() {
        rentViewModel.rentVehicle(vehicleId: rentCar.id) { result in
            switch result {
                case .success(_):
                    print("Coche alquilado")
                case .failure(let error):
                switch error {
                    case .USER_CANT_AFFORD_RENT:
                        showDialog(title: "Error", description: String(localized: "No tienes suficiente saldo para alquilar este vehículo, recarga tu saldo para poder alquilarlo."))
                        break;
                    case .USER_DOES_NOT_HAVE_LICENSE:
                    showDialog(title: "Error", description: String(localized: "No tienes un carnet de conducir registrado, debes registrar un carnet de conducir para poder alquilar un vehiculo."))
                        break;
                    case .USER_ALREADY_HAS_RENT:
                    showDialog(title: "Error", description: String(localized:"Ya tienes un coche alquilado, debes devolverlo para poder alquilar otro."))
                    break;
                    case .VEHICLE_NOT_AVAILABLE:
                    showDialog(title: "Error", description: String(localized:"Este vehículo ya está alquilado, selecciona otro vehículo."))
                    break;
                    default:
                    showDialog(title: "Error", description: String(localized:"Ha ocurrido un error al alquilar el vehículo, inténtalo de nuevo más tarde."))
                }
            }
        }
    }
}

/*#Preview {
    Group {
        // Titulo de la vista
        Text("Vehiculos")
            .font(.title)
        List {
            AvaiableCarCard(rentCar: RentCarModel(
                id: 1,
                plate: "1234ABC",
                numBastidor: "123456789",
                brand: "Seat",
                model: "Ibiza",
                color: "Rojo",
                fechaMatriculacion: Date.now.addingTimeInterval(-120000),
                imageUrl: "https://www.surmocion.com/wp-content/uploads/2023/04/SEAT-Ibiza-estática-frontal-1.jpg",
                precioHora: 10.0,
                available: true
            ))
            AvaiableCarCard(rentCar: RentCarModel(
                id: 2,
                plate: "5678DEF",
                numBastidor: "987654321",
                brand: "Renault",
                model: "Clio",
                color: "Azul",
                fechaMatriculacion: Date.now.addingTimeInterval(-120000),
                imageUrl: "https://www.renaultretailgroup.es/content/new_gama_clio/galeria_modelo/R-DAM_1021889.jpg",
                precioHora: 15.0,
                available: true
            ))
        }
    }
}*/
