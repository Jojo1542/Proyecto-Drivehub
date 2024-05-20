//
//  AddDriverLicenseView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 17/5/24.
//

import SwiftUI

struct AddDriverLicenseView: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    @Environment(\.presentationMode) var presentationMode;
    
    @State private var driverLicenseType: UserModel.DriverLicense.DriverLicenseType = .B
    @State private var driverLicenseNumber: String = ""
    @State private var driverLicenseIssuedDate: Date = Date()
    @State private var driverLicenseExpirationDate: Date = Date()
    
    /*
     Estado del botón de login y si se está iniciando sesion
     */
    @State private var loading = false;
    
    var body: some View {
        Form {
            Section("Tipo de permiso") {
                Picker("Tipo de permiso", selection: $driverLicenseType) {
                    ForEach(UserModel.DriverLicense.DriverLicenseType.allCases, id: \.self) { type in
                        HStack {
                            Image(systemName: getIconFromLicenseType(type: type))
                            Text(type.rawValue)
                        }
                    }
                }
            }
            
            Section("Número de permiso") {
                TextField("Número de permiso", text: $driverLicenseNumber)
            }
            
            Section("Fecha de expedición") {
                DatePicker("Fecha de expedición", selection: $driverLicenseIssuedDate, displayedComponents: .date)
            }
            
            Section("Fecha de caducidad") {
                DatePicker("Fecha de caducidad", selection: $driverLicenseExpirationDate, displayedComponents: .date)
            }
            
            Section {
                VStack(alignment: .center) {
                    Button(action: {
                        withAnimation(.bouncy) {
                            self.loading = true
                            // Añadir la licencia de conducir
                            self.uploadDriverLicense()
                        }
                    }, label: {
                        if (!loading) {
                            Text("Añadir licencia")
                                .frame(maxWidth: .infinity)
                        } else {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        }
                    })
                    .disabled(loading)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.accentColor)
                    .cornerRadius(10)
                }.frame(maxWidth: .infinity)
            }
        }
        .navigationBarTitle("Añadir permiso de conducir")
        .navigationTitle("Añadir permiso de conducir")
    }
    
    func uploadDriverLicense() {
        appViewModel.addDriverLicense(
            driverLicense: UserModel.DriverLicense(
                licenseNumber: driverLicenseNumber,
                type: driverLicenseType,
                expirationDate: driverLicenseExpirationDate,
                issueDate: driverLicenseIssuedDate
            )
        ) { result in
            switch result {
            case .success(_):
                showDialog(title: "Licencia de conducir añadida", description: "Se ha añadido la licencia de conducir correctamente.")
                self.loading = false
                self.presentationMode.wrappedValue.dismiss(); // Volver a la lista
            case .failure(let error):
                showDialog(title: "Error", description: "No se ha podido añadir la licencia de conducir. \(error?.rawValue ?? "")");
            }
        }
    }
}

#Preview {
    AddDriverLicenseView()
}
