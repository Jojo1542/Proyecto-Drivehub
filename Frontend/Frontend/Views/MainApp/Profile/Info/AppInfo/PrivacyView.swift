//
//  PrivacyView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 17/5/24.
//

import SwiftUI

struct PrivacyView: View {
    var body: some View {
        VStack(alignment: .leading) {
            List {
                Section(header: Text("Política de privacidad").font(.title3).bold()) {
                    Text("La privacidad de nuestros usuarios es muy importante para nosotros. Por ello, en esta sección te explicamos cómo tratamos tus datos personales.")
                        .font(.subheadline)
                        .padding(.bottom)
                    
                    Text("1. ¿Qué datos recopilamos?")
                        .font(.title3)
                        .bold()
                    Text("Recopilamos los datos que nos proporcionas al registrarte en la aplicación. Estos datos incluyen tu nombre, apellidos, correo electrónico y contraseña.")
                        .font(.subheadline)
                        .padding(.bottom)
                    
                    Text("2. ¿Para qué utilizamos tus datos?")
                        .font(.title3)
                        .bold()
                    Text("Utilizamos tus datos para autenticarte en la aplicación y para proporcionarte un servicio personalizado.")
                        .font(.subheadline)
                        .padding(.bottom)
                    
                    Text("3. ¿Con quién compartimos tus datos?")
                        .font(.title3)
                        .bold()
                    Text("No compartimos tus datos con terceros.")
                        .font(.subheadline)
                        .padding(.bottom)
                    
                    Text("4. ¿Cómo protegemos tus datos?")
                        .font(.title3)
                        .bold()
                    Text("Tus datos están protegidos mediante cifrado y medidas de seguridad.")
                        .font(.subheadline)
                        .padding(.bottom)
                    
                    Text("5. ¿Cómo puedes acceder a tus datos?")
                        .font(.title3)
                        .bold()
                    Text("Puedes acceder a tus datos en la sección de perfil de la aplicación.")
                        .font(.subheadline)
                        .padding(.bottom)
                    
                    Text("6. ¿Cómo puedes contactar con nosotros?")
                        .font(.title3)
                        .bold()
                    Text("Puedes contactar con nosotros en la dirección de correo electrónico contacto@drivehub.es")
                        .font(.subheadline)
                        .padding(.bottom)
                }
            }
        }
    }
}

#Preview {
    PrivacyView()
}
