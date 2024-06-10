//
//  LoginView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 12/4/24.
//

import SwiftUI

struct LoginView: View {
    
    /*
     Variables de entorno / Compartidas
     */
    @EnvironmentObject var authViewModel: AuthViewModel;
    
    /*
     Variables de control de formularios
     */
    @State private var email = "";
    @State private var password = "";
    
    /*
     Variables de control de alertas
     */
    @State private var isShowingAlert = false;
    @State private var alertMessage = "";
    @State private var alertTitle = "";
    
    /*
     Estado del botón de login y si se está iniciando sesion
     */
    @State private var loading = false;
    
    var body: some View {
        NavigationStack {
            VStack {
                // Logo de la empresa
                Image("Logo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 250)
                    .padding(.vertical, 20)

                // Campos a rellenar
                VStack(spacing: 10, content: {
                    InputFieldView(
                        text: $email,
                        icon: "envelope.fill",
                        placeholder: "hello@example.com",
                        type: .emailAddress,
                        keyboard: .emailAddress
                    )
                    
                    InputFieldView(
                        text: $password,
                        icon: "key.fill",
                        placeholder: String(localized: "Contraseña"),
                        isPassword: true
                    )
                })
                
                // Botón de inicio de sesión
                Button {
                    // Se especifica que todos los cambios hechos dentro de este botón tendrán animaciones cuando se apliquen cambios
                    withAnimation(.bouncy) {
                        realizeLogin();
                    }
                } label: {
                    if (!loading) {
                        HStack {
                            Text("Iniciar sesión").fontWeight(.bold)
                            Image(systemName: "arrow.forward.circle")
                        }
                        .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                    } else {
                        ProgressView()
                            .frame(width: UIScreen.main.bounds.width - 300, height: 48)
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                    }
                }
                .alert(isPresented: $isShowingAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .cancel(Text("OK")))
                }
                .disabled(loading)
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
                    .padding(.bottom, 20)
                }
            }
        }
    }
    
    /*
     Muestra una alerta en pantalla con los datos enviados
     */
    func showAlert(title: String, description: String) {
        alertTitle = title
        alertMessage = description
        isShowingAlert = true
    }
    
    /*
     Realiza el proceso de login del botón y tira error en caso necesario.
     */
    func realizeLogin() {
        // Se comprueba si todos los campos están rellenos, si no, tira error
        if (!email.isEmpty && !password.isEmpty) {
            
            // Se comprueba que el e-mail es válido, si no, tira error
            if (textFieldValidatorEmail(self.email)) {
                loading = true;
                
                authViewModel.login(email: email, password: password) { callback in
                    switch (callback) {
                        case .success(_):
                            debugPrint("Inicio de sesión correcto")
                        case let .failure(errorMsg):
                            // Mostramos el error lanzado por la aplicación y devuelto por el controlador. IMPORTANTE, los errores son devueltos ya traducidos.
                            showAlert(title: "Error", description: errorMsg!)
                            loading = false;
                    }
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
    LoginView()
}
