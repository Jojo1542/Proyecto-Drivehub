//
//  LoginView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 12/4/24.
//

import SwiftUI

struct LoginView: View {
    
    @State private var isEmailValid = false
    @State private var textEmail =  ""
    @State private var password = "";
    
    @State private var isShowingAlert = false;
    @State private var alertMessage = "";
    
    @EnvironmentObject var authViewModel: AuthViewModel;
    
    var body: some View {
        NavigationStack {
            VStack {
                // Logo de la empresa
                Image("Logo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 250)
                    .padding(.vertical, 20)
                
                // Espaciado
                //Spacer()

                // Campos
                VStack(spacing: 10, content: {
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
                    
                    InputFieldView(
                        text: $password,
                        icon: "key.fill",
                        placeholder: "Contraseña",
                        isPassword: true
                    ).autocapitalization(.none)
                })
                
                // Botón
                Button {
                    withAnimation(.spring) {
                        authViewModel.login(email: textEmail, password: password) { callback in
                            switch (callback) {
                                case let .success(_empty):
                                    debugPrint("Inicio de sesión correcto")
                                case let .failure(_errorCode):
                                    alertMessage = "Correo electronico o contraseña incorrectos. Intentelo de nuevo."
                                    isShowingAlert = true
                            }
                        }
                    }
                } label: {
                    HStack {
                        Text("Iniciar sesión").fontWeight(.bold)
                        Image("arrowshape.forward.circle")
                    }
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .alert(isPresented: $isShowingAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                .foregroundColor(.white)
                .background(Color.accentColor)
                .cornerRadius(10)
                
                // Espaciado
                Spacer()
                
                NavigationLink {
                    RegisterView()
                        .navigationTitle("Crea tu cuenta")
                } label: {
                    HStack {
                        Text("¿No tienes cuenta?")
                        Text("¡Crea una ahora!").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                    .font(.system(size: 18))
                    .foregroundColor(.accentColor)
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
