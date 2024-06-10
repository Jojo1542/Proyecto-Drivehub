//
//  AdminPermissionSelectionView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 30/5/24.
//

import SwiftUI

struct AdminPermissionSelectionView: View {
    
    typealias AdminPermission = UserModel.AdminData.AdminPermission;
    
    @Binding var adminPermissions: [AdminPermission];
    var saveAction: () -> Void;
    
    var body: some View {
        ForEach(AdminPermission.Category.allCases, id: \.self) { category in
            DisclosureGroup {
                ForEach(category.permissions, id: \.self) { permission in
                    Toggle(isOn: Binding<Bool>(
                        get: {
                            adminPermissions.contains(permission)
                        }, set: { value in
                            if value {
                                adminPermissions.append(permission)
                            } else {
                                adminPermissions.removeAll { $0 == permission }
                            }
                            
                            self.saveAction();
                        }
                    )) {
                        Text(permission.userFriendlyName)
                    }
                }
            } label: {
                Label(category.userFriendlyName, systemImage: category.icon)
            }
        }
    }
}
