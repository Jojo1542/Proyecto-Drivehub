//
//  ShipmentCreationFormView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 21/5/24.
//

import SwiftUI

struct ShipmentCreationFormView: View {
    
    @EnvironmentObject var viewModel: AdminShipmentViewModel;
    @EnvironmentObject var fleetModel: AdminFleetViewModel;
    
    @State private var sourceAddress: String = "";
    @State private var destinationAddress: String = "";
    @State private var shipmentDate: Date = Date();
    @State private var deliveryDate: Date = Date();
    @State private var parcels: [CreateShipmentRequest.RequestBody.Parcel] = [];
    @State private var driverData: UserModel? = nil;
    
    @State private var showDriverSelection: Bool = false;
    @State private var showParcelCreation: Bool = false;
    
    @State private var loading: Bool = false;
    
    var body: some View {
        Form {
            Section(header: Text("Información de envio")) {
                TextField("Dirección de origen", text: $sourceAddress).scrollDismissesKeyboard(.interactively);
                TextField("Dirección de destino", text: $destinationAddress).scrollDismissesKeyboard(.interactively);
                DatePicker("Fecha de envio", selection: $shipmentDate, in: Date()..., displayedComponents: .date);
                DatePicker("Fecha de entrega", selection: $deliveryDate, in: Date()..., displayedComponents: .date);
            }
            
            Section(header: Text("Paquetes")) {
                ForEach(parcels, id: \.id) { parcel in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(parcel.content)
                                .font(.headline)
                            Text("Cantidad: \(parcel.quantity)")
                                .font(.subheadline)
                            Text("Peso: \(parcel.weight.formatted()) kg")
                                .font(.subheadline)
                        }
                    }
                }
                
                Button(action: {
                    self.showParcelCreation = true;
                }, label: {
                    Label("Añadir paquete", systemImage: "plus");
                }).sheet(isPresented: $showParcelCreation, content: {
                    ParcelCreationSheetView(parcels: $parcels, isPresented: $showParcelCreation)
                });
            }
            
            Section(header: Text("Conductor")) {
                // Información del conductor
                if (driverData == nil) {
                    Text("Conductor no asignado");
                } else {
                    // Información del conductor
                    UserRow(user: driverData!)
                }
                
                // Botón para asignar conductor
                Button(action: {
                    self.showDriverSelection = true;
                }, label: {
                    Label("Asignar conductor", systemImage: "person");
                }).sheet(isPresented: $showDriverSelection, content: {
                    DriverSelectionSheetView(selectedDriver: $driverData, isPresented: $showDriverSelection)
                        .environmentObject(fleetModel);
                });
            }
            
            VStack(alignment: .center) {
                Button(action: {
                    withAnimation(.bouncy) {
                        self.loading = true;
                        processCreate();
                    }
                }) {
                    if (!loading) {
                        Text("Crear envio")
                            .frame(maxWidth: .infinity)
                    } else {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                    }
                }
                .disabled(loading || !isValid())
                .padding()
                .foregroundColor(.white)
                .background(isValid() ? Color.accentColor : Color.secondary.opacity(0.5))
                .cornerRadius(10)
            }.frame(maxWidth: .infinity)
            
        }
    }
    
    func isValid() -> Bool {
        return !sourceAddress.isEmpty 
        && !destinationAddress.isEmpty
        && shipmentDate < deliveryDate
        && driverData != nil
        && parcels.count > 0;
    }
    
    func processCreate() {
        self.viewModel.addShipment(data: CreateShipmentRequest.RequestBody(
            sourceAddress: sourceAddress,
            destinationAddress: destinationAddress,
            shipmentDate: shipmentDate,
            deliveryDate: deliveryDate,
            parcels: parcels,
            driverId: driverData!.id // A veces no se asigna un conductor cuando se crea un envio
        ), completion: { result in
            switch result {
                case .success(_):
                    self.sourceAddress = "";
                    self.destinationAddress = "";
                    self.shipmentDate = Date();
                    self.deliveryDate = Date();
                    self.parcels = [];
                    self.driverData = nil;
                    showDialog(title: "Envio creado", description: "El envio se ha creado correctamente");
                case .failure(let error):
                    switch error {
                        case .DRIVER_NOT_FOUND:
                            showDialog(title: "Error", description: "No se ha encontrado el conductor seleccionado");
                        break;
                        case .INVALID_SHIPMENT_DATE:
                            showDialog(title: "Error", description: "La fecha de envio no puede ser mayor a la fecha de entrega");
                        break;
                        case .PARCELS_CANNOT_BE_EMPTY:
                            showDialog(title: "Error", description: "Debe añadir al menos un paquete");
                        break;
                        default:
                            showDialog(title: "Error", description: "Ha ocurrido un error al crear el envio");
                        break;
                    }
                
                
            }
            
            withAnimation(.spring) {
                self.loading = false;
            }
        });
    }
}

#Preview {
    let authModel = PreviewHelper.authModelAdmin;
    let appModel = AppViewModel(authViewModel: authModel);
    
    return ShipmentCreationFormView()
        .environmentObject(authModel)
        .environmentObject(appModel)
        .environmentObject(AdminFleetViewModel(appModel: appModel))
        .environmentObject(AdminShipmentViewModel(appModel: appModel, fleetId: 1))
}
