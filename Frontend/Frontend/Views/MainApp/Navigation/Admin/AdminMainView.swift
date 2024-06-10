//
//  AdminMainView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 24/4/24.
//

import SwiftUI

struct AdminMainView: View {
    
    @EnvironmentObject var appViewModel: AppViewModel;
    typealias Permission = UserModel.AdminData.AdminPermission
    
    var user: UserModel {
        return appViewModel.getUser();
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: ListSectionHeader(title: "Gestión de Usuarios", icon: "person.fill")) {
                    
                    NavigationLink(destination: AdminUserList().environmentObject(AdminUserViewModel(appModel: appViewModel)), label: { Label("Lista de Usuarios", systemImage: "person.fill") });
                 
                    // Ver contratos
                    NavigationLink(destination: AdminGeneralContractListView()
                        .environmentObject(AdminContractViewModel(appModel: appViewModel)), label: { Label("Listar contratos de choffer", systemImage: "doc.text.fill") });
                    
                    // Crear contrato
                    NavigationLink(destination: AdminGeneralContractCreationView().environmentObject(AdminContractViewModel(appModel: appViewModel)), label: { Label("Crear contrato de choffer", systemImage: "doc.fill.badge.plus") });
                }
                
                Section(header: ListSectionHeader(title: "Gestión de Trayectos", icon: "figure.wave")) {
                    
                    // Listar las asignaciones
                    NavigationLink(destination: TripAdminList(onlyActive: true).environmentObject(AdminTripViewModel(appModel: appViewModel)), label: { Label("Lista de asignaciones", systemImage: "figure.run") });
                    
                    // Historial general de trayectos
                    NavigationLink(destination: TripAdminList(onlyActive: false).environmentObject(AdminTripViewModel(appModel: appViewModel)), label: { Label("Historial de trayectos", systemImage: "calendar") });
                }
                
                Section(header: ListSectionHeader(title: "Gestión de Alquiler", icon: "car.fill")) {
                    
                    NavigationLink(
                        destination: AdminVehicleListView().environmentObject(AdminVehicleViewModel(appModel: appViewModel)),
                        label: { Label("Lista de vehiculos", systemImage: "car.fill")
                    });
                    
                    NavigationLink(destination: VehicleCreationFormView().environmentObject(AdminVehicleViewModel(appModel: appViewModel)),
                        label: { Label("Añadir un nuevo vehiculo", systemImage: "plus.circle.fill")
                    });
                    
                }
                
                // Gestión de flota
                Section(header: ListSectionHeader(title: "Gestión de Flota", icon: "truck.pickup.side.fill")) {
                    
                    // Mis Flotas
                    NavigationLink(
                        destination: FleetListView(asSuperadmin: false).environmentObject(AdminFleetViewModel(appModel: appViewModel)),
                        label: { Label("Mis flotas", systemImage: "truck.pickup.side.fill")
                    });
                    
                    // Listar Todas las flotas
                    NavigationLink(
                        destination: FleetListView(asSuperadmin: true).environmentObject(AdminFleetViewModel(appModel: appViewModel)),
                        label: { Label("Listar todas las flotas", systemImage: "list.bullet.rectangle.fill")
                        });
                    
                }
                
                // Mantenimiento
                Section(header: ListSectionHeader(title: "Mantenimiento", icon: "hammer.fill")) {
                    // Información de salud de la app
                    NavigationLink(destination: EmptyView(), label: { Label("Salud de la app", systemImage: "heart.fill") });
                }
            }
        }
    }
    
    func hasPermission(permission: Permission) -> Bool {
        return user.adminData!.generalPermissions.contains(permission) || user.adminData!.generalPermissions.contains(Permission.SUPER_ADMIN);
    }
    
    func hasAnyPermission(permissions: [Permission]) -> Bool {
        for permission in permissions {
            if hasPermission(permission: permission) {
                return true;
            }
        }
        return false;
    }
}

#Preview {
    let authModel = PreviewHelper.authModelAdmin;
    let appModel = AppViewModel(authViewModel: authModel);
    
    return AdminMainView()
        .environmentObject(authModel)
        .environmentObject(appModel)
}
