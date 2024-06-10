//
//  AdminVehicleModifyView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 21/5/24.
//

import SwiftUI

struct AdminVehicleModifyView: View {
    
    @EnvironmentObject var viewModel: AdminVehicleViewModel;
    
    @Binding var vehicle: RentCarModel;
    @Binding var showModify: Bool;
    
    @State var showImagePicker: Bool = false;
    
    @State private var brand = ""
    @State private var model = ""
    @State private var color = ""
    @State private var fechaMatriculacion = Date()
    @State private var imageUrl = ""
    @State private var precioHora = 0.0
    
    var body: some View {
        Form {
            Section("Marca") {
                TextField("Marca", text: $brand)
            }
            
            Section("Modelo") {
                TextField("Modelo", text: $model)
            }
            
            Section("Color") {
                TextField("Color", text: $color)
            }
            
            Section("Fecha de matriculación") {
                DatePicker("Fecha de matriculación", selection: $fechaMatriculacion, displayedComponents: .date)
            }
            
            Section("Precio por hora") {
                // Only allow numbers
                TextField("Precio por hora", value: $precioHora, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                    .onChange(of: precioHora) { oldValue, newValue in
                        if newValue < 0 {
                            self.precioHora = 0.0
                        }
                    }

            }
            
            Section("Imagen") {
                if (!imageUrl.isEmpty) {
                    AsyncImage(url: URL(string: imageUrl)) { image in
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
                }
                
                TextField("URL de la imagen", text: $imageUrl)
            }
            
            VStack(alignment: .center) {
                Button(action: {
                    let newData = RentCarModel(
                        id: vehicle.id,
                        plate: vehicle.plate,
                        numBastidor: vehicle.numBastidor,
                        brand: brand,
                        model: model,
                        color: color,
                        fechaMatriculacion: fechaMatriculacion,
                        imageUrl: imageUrl,
                        precioHora: precioHora, 
                        available: vehicle.available
                    )
                    
                    viewModel.updateVehicle(data: vehicle) { result in
                        switch result {
                        case .success(_):
                            vehicle = newData;
                            showModify.toggle()
                        case .failure(_):
                            showDialog(title: "Error", description: "No se ha podido modificar el vehículo")
                        }
                    }
                }) {
                    Text("Modificar")
                        .frame(maxWidth: .infinity)
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.accentColor)
                .cornerRadius(10)
            }.frame(maxWidth: .infinity)
            
            
        }.onAppear() {
            self.brand = vehicle.brand
            self.model = vehicle.model
            self.color = vehicle.color
            self.fechaMatriculacion = vehicle.fechaMatriculacion
            self.imageUrl = vehicle.imageUrl ?? ""
            self.precioHora = vehicle.precioHora
        }
    }
}
