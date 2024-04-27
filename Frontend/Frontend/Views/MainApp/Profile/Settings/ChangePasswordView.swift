//
//  ChangePasswordView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 26/4/24.
//

import SwiftUI

struct ChangePasswordView: View {
    
    /*
     Variables de entorno / Compartidas
     */
    @EnvironmentObject var appModel: AppViewModel;
    
    /*
     Variables de control de formularios
     */
    @State private var password = "";
    @State private var passwordConfirm = "";
    
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
        VStack {
            List {
                Section(header: Text("Contraseña"), footer: Text("Es recomendable que la nueva contraseña contenga al menos 8 caracteres, un numero, una letra mayuscula y una minuscula.")) {
                    SecureField("Nueva contraseña", text: $password)
                    SecureField("Repetir nueva contraseña", text: $passwordConfirm)
                }
                
                VStack(alignment: .center) {
                    Button(action: {
                        withAnimation(.bouncy) {
                            realizeChange();
                        }
                    }, label: {
                        if (!loading) {
                            Text("Confirmar Cambio")
                                .frame(maxWidth: .infinity)
                        } else {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        }
                    })
                    .alert(isPresented: $isShowingAlert) {
                        Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .cancel(Text("OK")))
                    }
                    .disabled(loading)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.accentColor)
                    .cornerRadius(10)
                }.frame(maxWidth: .infinity)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Cambio de contraseña")
    }
    
    /*
     Realiza el proceso de login del botón y tira error en caso necesario.
     */
    func realizeChange() {
        if (!password.isEmpty && !passwordConfirm.isEmpty) {
            if (password == passwordConfirm) {
                loading = true
                
                self.appModel.updatePassword(newPassword: password) { result in
                    switch result {
                        case .success(_):
                            showAlert(title: "Éxito", description: String(localized: "La contraseña se ha cambiado correctamente."))
                        case .failure(_):
                            showAlert(title: "Error", description: String(localized: "No se ha podido cambiar la contraseña, por favor intentalo de nuevo más tarde."))
                    }
                    
                    self.loading = false;
                }
            } else {
                showAlert(title: "Error", description: String(localized: "Las contraseñas no coinciden."))
            }
        } else {
            showAlert(title: "Error", description: String(localized: "Se debe rellenar la contraseña y la confirmación de la contraseña."))
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
    
}

#Preview {
    ChangePasswordView()
        .environmentObject(PreviewHelper.authModelUser)
}
