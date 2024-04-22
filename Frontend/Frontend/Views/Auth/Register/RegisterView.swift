//
//  RegisterView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 12/4/24.
//

import SwiftUI

struct RegisterView: View {
    
    @Environment(\.presentationMode) var presentationMode;
    
    @State private var isEmailValid = false
    @State private var textEmail =  ""
    
    @State private var firstName = "";
    @State private var lastName = "";
    @State private var password = "";
    @State private var passwordConfirm = "";
    
    @State private var isShowingAlert = false;
    @State private var alertMessage = "";
    @State private var goBackOnOk = false;
    
    @EnvironmentObject var authViewModel: AuthViewModel;
    
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
                            placeholder: "Nombre"
                        ).autocapitalization(.none)
                        
                        InputFieldView(
                            text: $lastName,
                            icon: "person.fill.viewfinder",
                            placeholder: "Apellidos"
                        ).autocapitalization(.none)
                        
                        InputFieldView(
                            text: $textEmail,
                            icon: "envelope.fill",
                            placeholder: "hello@example.com",
                            validator: {(changed) in
                                if (!changed) {
                                    if textFieldValidatorEmail(self.textEmail) {
                                        self.isEmailValid = true
                                    } else {
                                        self.isEmailValid = false
                                        self.textEmail = ""
                                        
                                        alertMessage = "El email no es válido. Por favor, inténtelo de nuevo."
                                        isShowingAlert = true
                                    }
                                }
                            }
                        ).autocapitalization(.none)
                        .alert(isPresented: $isShowingAlert) {
                            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                        }
                    })
                    
                    Text("Contraseña")
                        .fontWeight(.bold)
                        .padding(.top, 20)
                    
                    // Campos de contraseña
                    VStack(spacing: 10, content: {
                        InputFieldView(
                            text: $password,
                            icon: "key.fill",
                            placeholder: "Contraseña",
                            isPassword: true
                        ).autocapitalization(.none)
                        
                        InputFieldView(
                            text: $passwordConfirm,
                            icon: "key.fill",
                            placeholder: "Confirma Contraseña",
                            isPassword: true
                        ).autocapitalization(.none)
                    })
                    
                    // Botón
                    // TODO: Validar todos los campos y rellenar todo
                    Button {
                        if (password == passwordConfirm) {
                            authViewModel.createAccount(email: textEmail, password: password, firstName: firstName, lastName: lastName) { callback in
                                    switch (callback) {
                                        case let .success(_empty):
                                            alertMessage = "Cuenta registrada, por favor inicie sesión."
                                            isShowingAlert = true
                                            goBackOnOk = true // Establecer que se tiene que volver al login
                                        case let .failure(_errorCode):
                                            alertMessage = "El correo electrónico introducido ya está registrado."
                                            isShowingAlert = true
                                    }
                                }
                        } else {
                            alertMessage = "Las contraseñas introducidas deben ser iguales."
                            isShowingAlert = true
                        }
                    } label: {
                        HStack {
                            Text("Crear cuenta").fontWeight(.bold)
                            Image("person.badge.plus")
                        }
                        .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                    }
                    .alert(isPresented: $isShowingAlert) {
                        Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .cancel(Text("OK"), action: {
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
}

#Preview {
    RegisterView()
}
