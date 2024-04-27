//
//  RegisterView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 12/4/24.
//

import SwiftUI

struct RegisterView: View {
    
    /*
     Variables de entorno
     */
    @EnvironmentObject var authViewModel: AuthViewModel;
    @Environment(\.presentationMode) var presentationMode;
    
    /*
     Variables de control de formularios
     */
    @State private var email =  ""
    @State private var firstName = "";
    @State private var lastName = "";
    @State private var password = "";
    @State private var passwordConfirm = "";
    
    /*
     Variables de control de alertas
     */
    @State private var isShowingAlert = false;
    @State private var alertMessage = "";
    @State private var alertTitle = "";
    @State private var goBackOnOk = false;
    
    var body: some View {
        ScrollView {
            ZStack {
                // Espacio arriba
                Spacer().containerRelativeFrame([.horizontal, .vertical])
                
                VStack {
                    Spacer()
                    
                    Text("Datos Personales")
                        .fontWeight(.bold)
                    
                    // Campos principales
                    VStack(spacing: 10, content: {
                        InputFieldView(
                            text: $firstName,
                            icon: "person.text.rectangle",
                            placeholder: String(localized: "Nombre"),
                            type: .givenName
                        )
                        
                        InputFieldView(
                            text: $lastName,
                            icon: "person.fill.viewfinder",
                            placeholder: String(localized: "Apellidos"),
                            type: .familyName
                        )
                        
                        InputFieldView(
                            text: $email,
                            icon: "envelope.fill",
                            placeholder: "hello@example.com",
                            type: .emailAddress,
                            keyboard: .emailAddress
                        )
                    })
                    
                    Text("Contraseña")
                        .fontWeight(.bold)
                        .padding(.top, 20)
                    
                    // Campos de contraseña
                    VStack(spacing: 10, content: {
                        InputFieldView(
                            text: $password,
                            icon: "key.fill",
                            placeholder: String(localized: "Contraseña"),
                            isPassword: true
                        )
                        
                        InputFieldView(
                            text: $passwordConfirm,
                            icon: "key.fill",
                            placeholder: String(localized: "Confirmar Contraseña"),
                            isPassword: true
                        )
                    })
                    
                    // Botón de confirmar el registro
                    Button {
                        realizeRegister();
                    } label: {
                        HStack {
                            Text("Crear cuenta").fontWeight(.bold)
                            Image(systemName: "person.badge.plus")
                        }
                        .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                    }
                    // Muestra una alerta que sale de este objeto
                    .alert(isPresented: $isShowingAlert) {
                        Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .cancel(Text("OK"), action: {
                            if (goBackOnOk) {
                                self.presentationMode.wrappedValue.dismiss(); // Volver al login
                            }
                        }))
                    }
                    .foregroundColor(.white)
                    .background(Color.accentColor)
                    .cornerRadius(10)
                    
                    // Espaciado
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width, height: 48)
                .padding()
            }
        }
    }
    
    /*
     Muestra una alerta en pantalla con los datos enviados
     */
    func showAlert(title: String, description: String, goBack: Bool = false) {
        alertTitle = title
        alertMessage = description
        isShowingAlert = true
        goBackOnOk = goBack
    }
    
    /*
     Realiza el proceso de registro del botón y tira error en caso necesario.
     */
    func realizeRegister() {
        // Se comprueba si todos los campos están rellenos, si no, tira error
        if (!firstName.isEmpty && !lastName.isEmpty && !email.isEmpty && !password.isEmpty && !passwordConfirm.isEmpty) {
            
            // Se comprueba que el e-mail es válido, si no, tira error
            if (textFieldValidatorEmail(self.email)) {
                
                // Se comprueba que la contraseñas son iguales, si no, tira error
                if (password == passwordConfirm) {
                    
                    // Manda una solicitud de crear cuenta, y maaneja sus excepciones
                    authViewModel.createAccount(email: email, password: password, firstName: firstName, lastName: lastName) { callback in
                        switch (callback) {
                            case .success(_):
                                // Avisamos al usuario de que se ha podido crear su cuenta
                                showAlert(title: "¡Cuenta registrada!", description: String(localized: "Tu cuenta ha sido registrada, vuelve al la pantalla anterior para iniciar sesión"), goBack: true)
                            case let .failure(errorMsg):
                                // Mostramos el error lanzado por la aplicación y devuelto por el controlador. IMPORTANTE, los errores son devueltos ya traducidos.
                                showAlert(title: "Error", description: errorMsg!)
                        }
                    }
                } else {
                    showAlert(title: "Error", description: String(localized: "Las contraseñas introducidas deben ser iguales."))
                }
            } else {
                showAlert(title: "Error", description: String(localized: "No se ha introducido un E-Mail válido, comprueba de nuevo."))
            }
        } else {
            showAlert(title: "Error", description: String(localized: "Algúno de los campos no se encuentra relleno, comprueba e intentalo de nuevo."))
        }
    }
}

#Preview {
    RegisterView()
}
