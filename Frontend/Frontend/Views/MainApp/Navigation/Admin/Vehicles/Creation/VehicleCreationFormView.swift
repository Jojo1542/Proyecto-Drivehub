//
//  VehicleCreationFormView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 21/5/24.
//

import SwiftUI

struct VehicleCreationFormView: View {
    
    @EnvironmentObject var viewModel: AdminVehicleViewModel;
    
    @State private var plate = ""
    @State private var numBastidor = ""
    @State private var brand = ""
    @State private var model = ""
    @State private var color = ""
    @State private var fechaMatriculacion = Date()
    @State private var imageUrl = ""
    @State private var precioHora = 0.0
    
    @State private var loading = false;
    
    var body: some View {
        Form {
            Section("Identificación") {
                TextField("Matrícula", text: $plate)
                TextField("Número de bastidor", text: $numBastidor)
            }
            
            Section("Datos") {
                TextField("Marca", text: $brand)
                TextField("Modelo", text: $model)
                TextField("Color", text: $color)
                DatePicker("Fecha de matriculación", selection: $fechaMatriculacion, displayedComponents: .date)
            }
            
            Section("Precio por hora") {
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
                    withAnimation(.bouncy) {
                        self.loading = true;
                        createVehicle();
                    }
                }) {
                    if (!loading) {
                        Text("Crear vehiculo")
                            .frame(maxWidth: .infinity)
                    } else {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                    }
                }
                .disabled(loading)
                .padding()
                .foregroundColor(.white)
                .background(Color.accentColor)
                .cornerRadius(10)
            }.frame(maxWidth: .infinity)
        }.navigationTitle("Añadir un nuevo vehiculo")
    }
    
    func createVehicle() {
        if (!plate.isEmpty && !numBastidor.isEmpty && !brand.isEmpty && !model.isEmpty && !color.isEmpty && !imageUrl.isEmpty && precioHora > 0) {
            let vehicle = CreateVehicleRequest.RequestBody(
                plate: plate,
                numBastidor: numBastidor,
                brand: brand,
                model: model,
                color: color,
                fechaMatriculacion: fechaMatriculacion,
                imageUrl: imageUrl.isEmpty ? nil : imageUrl,
                precioHora: precioHora
            );
            
            viewModel.createVehicle(data: vehicle) { result in
                switch result {
                    case .success(_):
                        // Reiniciar formulario
                        self.plate = ""
                        self.numBastidor = ""
                        self.brand = ""
                        self.model = ""
                        self.color = ""
                        self.fechaMatriculacion = Date()
                        self.imageUrl = ""
                        self.precioHora = 0.0
                
                        // Avisar al usuario
                        showDialog(title: String(localized: "Éxito"), description: String(localized: "Vehículo creado correctamente"))
                    
                    case .failure(let error):
                    switch error {
                        case .PLATE_ALREADY_EXISTS:
                            showDialog(title: String(localized: "Error"), description: String(localized: "La matrícula ya existe en el sistema."))
                        break;
                        case .BASTIDOR_ALREADY_EXISTS:
                            showDialog(title: String(localized: "Error"), description: String(localized: "El número de bastidor ya existe en el sistema."))
                        break;
                        default:
                            showDialog(title: String(localized: "Error"), description: String(localized: "Ha ocurrido un error inesperado. Por favor, inténtelo de nuevo."))
                        break;
                            
                    }
                }
                
                withAnimation(.spring) {
                    self.loading = false;
                }
            }
        } else {
            showDialog(title: String(localized: "Error"), description: String(localized: "Por favor, rellene todos los campos"))
        }
    }
}

#Preview {
    let authModel = PreviewHelper.authModelAdmin;
    let appModel = AppViewModel(authViewModel: authModel);
    
    return VehicleCreationFormView()
        .environmentObject(authModel)
        .environmentObject(appModel)
        .environmentObject(AdminVehicleViewModel(appModel: appModel))
}
