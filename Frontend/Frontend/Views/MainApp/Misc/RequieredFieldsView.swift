//
//  RequieredFieldsView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 24/4/24.
//

import SwiftUI

struct RequieredFieldsView: View {
    
    /*
     Variables de entorno / Compartidas
     */
    @EnvironmentObject var authViewModel: AuthViewModel;
    @EnvironmentObject var appViewModel: AppViewModel;
    
    /*
     Variables de control de formularios
     */
    @State private var dni = "";
    @State private var date = Date();
    
    /*
     Variables de control de alertas
     */
    @State private var isShowingAlert = false;
    @State private var alertMessage = "";
    @State private var alertTitle = "";
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20, content: {
                Text("¡Bienvenido a DriveHub!")
                    .font(.title)
                    .bold()
                    .padding(.top, 50)
                
                Text("Bienvenido a la plataforma donde todo lo relacionado con la carretera se une. Para poder empezar necesitamos algunos datos para comprobar que eres humano y que eres mayor de edad.")
                    .font(.subheadline)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 10)
            })
            
            VStack(alignment: .leading, spacing: 10, content: {
                Text("DNI:")
                    .font(.title2)
                    .padding(.horizontal, 20)
                
                InputFieldView(
                    text: $dni,
                    icon: "person.text.rectangle",
                    placeholder: "99999999R"
                )
                
                Text("Fecha de nacimiento:")
                    .font(.title2)
                    .padding(.horizontal, 20)
                
                InputDatePickerView(
                    date: $date,
                    icon: "calendar",
                    name: "Fecha de nacimiento"
                )
            })
            .padding(.vertical, 30)
            
            Spacer()
            
            Button {
                withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.5)) {
                    processInfo();
                }
            } label: {
                HStack {
                    Text("Guardar cambios").fontWeight(.bold)
                    Image(systemName: "square.and.arrow.down")
                }
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            }
            .alert(isPresented: $isShowingAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .foregroundColor(.white)
            .background(Color.accentColor)
            .cornerRadius(10)
        }
        .listStyle(.inset)
    }
    
    func calculateYears() -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: Date()).year!
    }
    
    /*
     Muestra una alerta en pantalla con los datos enviados
     */
    func showAlert(title: String, description: String) {
        alertTitle = title
        alertMessage = description
        isShowingAlert = true
    }
    
    func processInfo() {
        // Si el DNI es valido
        if (CustomerIdentifierValidator.validate(document: .dniNie(number: dni))) {
            if (calculateYears() >= 18) {
                authViewModel.currentUser?.dni = dni;
                authViewModel.currentUser?.birthDate = date;
                
                appViewModel.saveAndUpdateUser(completion: { result in
                    switch result {
                        case .success(_):
                            showAlert(title: "Éxito", description: String(localized: "La contraseña se ha cambiado correctamente."))
                        case .failure(let reason):
                            switch reason! {
                                case UserUpdateRequest.ErrorType.DNI_ALREADY_IN_USE:
                                    showAlert(title: "Error", description: "El DNI introducido ya está en uso.")
                                default:
                                    debugPrint("Error saving user: \(reason!)")
                                    showAlert(title: "Error", description: "Ha ocurrido un error inesperado, prueba de nuevo más tarde.")
                            }
                            
                            // No permitir al usuario continuar si no tiene el DNI ya que no se ha podido guardar.
                            authViewModel.currentUser?.dni = nil;
                    }
                })
            } else {
                showAlert(title: "Error", description: "Debes ser mayor de edad para poder usar DriveHub.")
            }
        } else {
            showAlert(title: "Error", description: "El DNI introducido no es valido, reviselo.")
        }
    }
}

#Preview {
    RequieredFieldsView()
}
