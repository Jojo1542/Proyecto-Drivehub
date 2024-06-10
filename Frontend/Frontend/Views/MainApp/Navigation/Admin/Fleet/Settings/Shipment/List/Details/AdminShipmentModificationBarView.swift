//
//  AdminShipmentModificationBarView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 21/5/24.
//

import SwiftUI

struct AdminShipmentModificationBarView: View {
    
    @Binding var shipment: ShipmentModel;
    
    @State var isDriverPickerPresented: Bool = false;
    @State var isDatePickerPresented: Bool = false;
    @State var isStatusHidden: Bool = false;
    
    @State var selectedDate: Date = Date();
    
    var body: some View {
        HStack {
            Button(action: {
                // Cambiar conductor
            }, label: {
                Text("Cambiar conductor")
            })
            .padding()
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            
            Button(action: {
                // Cambiar fecha de entrega
                isDatePickerPresented.toggle()
            }, label: {
                Text("Cambiar fecha de entrega")
            })
            .padding()
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(10)
            .sheet(isPresented: $isDatePickerPresented, content: {
                VStack {
                    DatePicker("Fecha de entrega", selection: $selectedDate, displayedComponents: [.date])
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .presentationDetents([.fraction(0.65)])
                        
                    Button(action: {
                        // Ocultar date picker
                        isDatePickerPresented.toggle()
                        
                        shipment.deliveryDate = selectedDate
                    }, label: {
                        Text("Aceptar")
                    })
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                }
            })
            
            Button(action: {
                // Ocultar estado de la entrega
                isStatusHidden.toggle()
                
                shipment.hidden = isStatusHidden
            }, label: {
                if (isStatusHidden) {
                    Text("Estado: Oculto")
                } else {
                    Text("Estado: Visible")
                }
            })
            .padding()
            .background(isStatusHidden ? Color.red : Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .onAppear() {
            isStatusHidden = shipment.hidden
            selectedDate = shipment.deliveryDate
        }
    }
}
