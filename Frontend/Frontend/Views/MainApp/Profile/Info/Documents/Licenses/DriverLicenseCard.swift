//
//  DriverLicenseCard.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 17/5/24.
//

import SwiftUI

struct DriverLicenseCard: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    var driverLicense: UserModel.DriverLicense;
    
    var body: some View {
        HStack {
            Image(systemName: getIconFromLicenseType(type: driverLicense.type))
                .resizable()
                .frame(width: 50, height: 50)
                .padding(.trailing, 10)
            
            VStack(alignment: .leading) {
                Text(driverLicense.licenseNumber)
                    .font(.headline)
                Text("Tipo: \(driverLicense.type.rawValue)")
                    .font(.subheadline)
                Text("Expira: \(driverLicense.expirationDate, style: .date)")
                    .font(.subheadline)
                Text("Emitido: \(driverLicense.issueDate, style: .date)")
                    .font(.subheadline)
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                processDeleteDriverLicense()
            } label: {
                Label("Eliminar", systemImage: "trash")
            }
        }
    }
    
    func processDeleteDriverLicense() {
        appViewModel.deleteDriverLicense(licenseId: driverLicense.licenseNumber) { result in
            switch result {
                case .success(_):
                    print("Licencia eliminada correctamente")
                case .failure(let error):
                    switch error {
                        case .LICENSE_NOT_FOUND:
                            showDialog(title: "Error", description: "No se ha encontrado la licencia en el sistema, refresca la lista de licencias.")
                            break;
                        default:
                            showDialog(title: "Error", description: "Ha ocurrido un error desconocido, por favor, inténtalo de nuevo.")
                        
                    }
            }
        }
    }
}
