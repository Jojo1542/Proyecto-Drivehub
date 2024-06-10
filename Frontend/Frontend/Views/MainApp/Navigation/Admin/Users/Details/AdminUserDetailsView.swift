//
//  AdminUserDetailsView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 30/5/24.
//

import SwiftUI

struct AdminUserDetailsView: View {
    
    typealias AdminPermission = UserModel.AdminData.AdminPermission;
    
    @EnvironmentObject var viewModel: AdminUserViewModel;
    
    @State var user: UserModel;
    
    @State var userRoles: [UserModel.Role] = [];
    @State var adminPermissions: [AdminPermission] = [];
    @State var fleet: FleetModel? = nil;
    
    var formatter = RelativeDateTimeFormatter();
    
    var body: some View {
        List {
            Section(header: Text("Información personal")) {
                HStack {
                    Text("Nombre completo")
                        .font(.headline)
                    Spacer()
                    Text(user.fullName)
                }
                HStack {
                    Text("DNI")
                        .font(.headline)
                    Spacer()
                    Text(user.dni ?? "No disponible")
                }
                HStack {
                    Text("Email")
                        .font(.headline)
                    Spacer()
                    Text(user.email)
                }
                HStack {
                    Text("Teléfono")
                        .font(.headline)
                    Spacer()
                    Text(user.phone ?? "No disponible")
                }
                HStack {
                    Text("Fecha de nacimiento")
                        .font(.headline)
                    Spacer()
                    Text(user.birthDate?.formatted(date: .complete, time: .omitted) ?? "No disponible")
                }
            }
            
            Section("Saldo") {
                HStack {
                    Text("Saldo")
                        .font(.headline)
                    Spacer()
                    Text("\(user.balance, specifier: "%.2f") €")
                }
                
                DisclosureGroup("Historial del saldo") {
                    ForEach(user.balanceHistoryList, id: \.id) { movimiento in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(movimiento.type == .DEPOSIT ? "Ingreso" : "Gasto")
                                    .font(.title3)
                                
                                // Relative time
                                Text(formatter.localizedString(for: movimiento.date, relativeTo: Date()))
                                    .font(.subheadline)
                                
                            }
                            Spacer()
                            Text("\(movimiento.type == .DEPOSIT ? "+" : "-")\(movimiento.amount.formatted()) €")
                                .font(.title3)
                        }
                    }
                    
                    if user.balanceHistory == nil || user.balanceHistory!.isEmpty {
                        Text("No hay movimientos")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Boton para modificar el saldo
                NavigationLink(destination: BalanceModificationFormView(user: $user).environmentObject(viewModel)) {
                    HStack {
                        Image(systemName: "plus.circle")
                        Text("Modificar balance")
                    }
                    .foregroundColor(.accentColor)
                }
            }
            
            if (user.roles.contains(.CHAUFFEUR)) {
                Section("Chofer") {
                    HStack {
                        Text("Disponibilidad")
                            .font(.headline)
                        Spacer()
                        Text(user.driverData?.avaiableTime ?? "No disponible")
                    }
                    
                    HStack {
                        Text("Vehículo")
                            .font(.headline)
                        Spacer()
                        Text(user.driverData?.vehicleModel ?? "No disponible")
                    }
                    
                    HStack {
                        Text("Matrícula")
                            .font(.headline)
                        Spacer()
                        Text(user.driverData?.vehiclePlate ?? "No disponible")
                    }
                    
                    HStack {
                        Text("Color")
                            .font(.headline)
                        Spacer()
                        Text(user.driverData?.vehicleColor ?? "No disponible")
                    }
                }
            }
            
            if (user.roles.contains(.FLEET)) {
                Section("Conductor de Flota") {
                    HStack {
                        Text("Disponibilidad")
                            .font(.headline)
                        Spacer()
                        Text(user.driverData?.avaiableTime ?? "No disponible")
                    }
                    
                    if (fleet != nil) {
                        FleetRow(fleet: fleet!)
                    }
                }
            }
            
            Section(header: Text("Roles")) {
                Toggle(isOn: Binding<Bool>(
                    get: {
                        userRoles.contains(.ADMIN)
                    }, set: { value in
                        if value {
                            userRoles.append(.ADMIN)
                        } else {
                            userRoles.removeAll { $0 == .ADMIN }
                        }
                        
                        self.processRoleSaving()
                    }
                )) {
                    Text("Administrador")
                }
                
                if userRoles.contains(.ADMIN) {
                    DisclosureGroup("Permisos de administrador") {
                        AdminPermissionSelectionView(adminPermissions: $adminPermissions) {
                            self.processAdminPermissionsSaving()
                        }
                    }
                }
            }
        }.onAppear() {
            self.userRoles = user.roles;
            self.adminPermissions = user.adminData?.generalPermissions ?? [];
        }
        .navigationTitle(user.fullName)
    }
    
    func processRoleSaving() {
        viewModel.updateUser(userId: user.id, request: UserUpdateByAdminRequest.RequestBody(roles: userRoles)) { result in
            if case let .failure(error) = result {
                showDialog(title: "Error", description: "No se han podido actualizar los permisos de administrador")
            }
        }
    }
    
    func processAdminPermissionsSaving() {
        viewModel.updateAdminPermissions(userId: user.id, perms: adminPermissions) { result in
            if case let .failure(error) = result {
                showDialog(title: "Error", description: "No se han podido actualizar los permisos de administrador")
            }
        }
    }
}
