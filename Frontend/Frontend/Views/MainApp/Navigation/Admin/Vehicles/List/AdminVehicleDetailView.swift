//
//  AdminVehicleDetailView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 21/5/24.
//

import SwiftUI

struct AdminVehicleDetailView: View {
    
    @EnvironmentObject var viewModel: AdminVehicleViewModel;
    
    @State var vehicle: RentCarModel;
    @State var showingModify: Bool = false
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: vehicle.imageUrl!)) { image in
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
            
            List {
                Section("Información") {
                    HStack {
                        Text("Marca")
                            .fontWeight(.bold)
                        Spacer()
                        Text(vehicle.brand)
                            .fontWeight(.medium)
                    }
                    
                    HStack {
                        Text("Modelo")
                            .fontWeight(.bold)
                        Spacer()
                        Text(vehicle.model)
                            .fontWeight(.medium)
                    }
                    
                    HStack {
                        Text("Matrícula")
                            .fontWeight(.bold)
                        Spacer()
                        Text(vehicle.plate)
                            .fontWeight(.medium)
                    }
                    // Copiar la matricula
                    .onTapGesture {
                        UIPasteboard.general.string = vehicle.plate
                        // Show a toast
                        showDialog(title: "Matrícula copiada", description: vehicle.plate)
                    }
                    
                    HStack {
                        Text("Numero de Bastidor")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(vehicle.numBastidor)")
                            .fontWeight(.medium)
                    }
                    
                    HStack {
                        Text("Color")
                            .fontWeight(.bold)
                        Spacer()
                        Text(vehicle.color)
                            .fontWeight(.medium)
                    }
                    
                    HStack {
                        Text("Precio por hora")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(vehicle.precioHora, specifier: "%.2f") €")
                            .fontWeight(.medium)
                    }
                    
                    HStack {
                        Text("Disponible")
                            .fontWeight(.bold)
                        Spacer()
                        Text(vehicle.available ? "Sí" : "No")
                            .fontWeight(.medium)
                    }
                    
                    HStack {
                        Text("Fecha de matriculación")
                            .fontWeight(.bold)
                        Spacer()
                        Text(vehicle.fechaMatriculacion, style: .date)
                            .fontWeight(.medium)
                    }
                }
                
                // Botón de editar
                Section {
                    Button(action: {
                        showingModify.toggle()
                    }) {
                        HStack {
                            Spacer()
                            Text("Editar")
                                .fontWeight(.bold)
                            Spacer()
                        }
                    }
                }
            }
        }.navigationTitle("Detalles del vehículo")
        .sheet(isPresented: $showingModify) {
            AdminVehicleModifyView(vehicle: $vehicle, showModify: $showingModify)
                .environmentObject(viewModel)
        }
    }
}
