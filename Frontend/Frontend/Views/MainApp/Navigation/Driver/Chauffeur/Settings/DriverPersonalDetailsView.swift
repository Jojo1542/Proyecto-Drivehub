//
//  DriverPersonalDetailsView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 25/5/24.
//

import SwiftUI

struct DriverPersonalDetailsView: View {
    
    @EnvironmentObject var viewModel: ChauffeurDriverViewModel;
    @EnvironmentObject var authModel: AuthViewModel;
    
    @State var preferredDistance: Double = 1.0
    
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date()
    
    @State private var loading: Bool = false;
    
    var body: some View {
        ZStack {
            if loading {
                ProgressView("Guardando cambios...")
                    .progressViewStyle(CircularProgressViewStyle())
            }
            
            Form {
                Stepper("Distancia preferida: \(preferredDistance.formatted()) Km", value: $preferredDistance, in: 1...1000, step: 0.1)
                
                VStack {
                    DatePicker("Hora de inicio", selection: $startTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(CompactDatePickerStyle())
                    
                    DatePicker("Hora de fin", selection: $endTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(DefaultDatePickerStyle())
                }
                
                
                Button {
                    self.loading = true;
                    
                    // Formatear las fechas seleccionadas
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH:mm"
                    
                    let startString = dateFormatter.string(from: startTime)
                    let endString = dateFormatter.string(from: endTime)
                    
                    let availableString = "\(startString)-\(endString)"
                    
                    viewModel.updatePersonalData(avaiableTime: availableString, preferedDistance: preferredDistance) { result in
                        switch result {
                        case .success(_):
                            authModel.currentUser?.driverData?.avaiableTime = availableString;
                            authModel.currentUser?.driverData?.preferedDistance = preferredDistance;
                            
                            showDialog(title: "Cambios guardados", description: "Los cambios se han guardado correctamente.");
                            break;
                        case .failure(let error):
                            showDialog(title: "Error", description: "No se han podido guardar los cambios. Error: \(error ?? 0)")
                            break;
                        }
                        
                        self.loading = false;
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text("Guardar cambios")
                        Spacer()
                    }
                }
                
            }
            .disabled(loading)
        }.onAppear() {
            preferredDistance = authModel.currentUser?.driverData?.preferedDistance ?? 1.0
            
            // Si es 0, colocar en 1.
            if preferredDistance < 1.0 {
                preferredDistance = 1.0
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            
            startTime = dateFormatter.date(from: authModel.currentUser?.driverData?.avaiableTime.components(separatedBy: "-")[0] ?? "00:00") ?? Date()
            
            endTime = dateFormatter.date(from: authModel.currentUser?.driverData?.avaiableTime.components(separatedBy: "-")[1] ?? "00:00") ?? Date()
        }
        .navigationTitle("Ajustes personales")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    DriverPersonalDetailsView()
}
