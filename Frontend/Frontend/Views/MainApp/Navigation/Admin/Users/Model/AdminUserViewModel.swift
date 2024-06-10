//
//  AdminUserViewModel.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 30/5/24.
//

import Foundation

class AdminUserViewModel: ObservableObject {
    private var appViewModel: AppViewModel;
    
    @Published var users: [UserModel] = []
    
    init (appModel: AppViewModel) {
        self.appViewModel = appModel;
    }
    
    public func fetchUsers() {
        GetAllUsersRequest.getAllUsers(sessionToken: appViewModel.getSessionToken()) { result in
            switch result {
            case .success(let data):
                self.users = data!;
            case .failure(let error):
                print("Fetch users failed with error \(error!)")
            }
        }
    }
    
    public func updateBalance(userId: Int, data: UserUpdateBalanceRequest.RequestBody, completion: @escaping (Callback<Void, Int>) -> Void) {
        UserUpdateBalanceRequest.updateBalance(sessionToken:  appViewModel.getSessionToken(), userId: userId, body: data) { result in
            switch result {
            case .success(_):
                self.fetchUsers();
                completion(.success())
            case .failure(let error):
                print("Error updating balance, status: \(error ?? 0)")
                completion(.failure(data: error!))
            }
        }
    }
    
    public func updateAdminPermissions(userId: Int, perms: [UserModel.AdminData.AdminPermission], completion: @escaping (Callback<Void, Int>) -> Void) {
        UserUpdateAdminPermissionsRequest.updatePermission(sessionToken: appViewModel.getSessionToken(), userId: userId, body: UserUpdateAdminPermissionsRequest.RequestBody(permissions: perms)) { result in
            switch result {
            case .success(_):
                self.fetchUsers();
                completion(.success())
            case .failure(let error):
                print("Error updating permissions, status: \(error ?? 0)")
                completion(.failure(data: error!))
            }
        }
    }
    
    public func updateUser(userId: Int, request: UserUpdateByAdminRequest.RequestBody, completion: @escaping (Callback<Void, Int>) -> Void) {
        UserUpdateByAdminRequest.updateUser(sessionToken: appViewModel.getSessionToken(), userId: userId, body: request) { result in
            switch result {
            case .success(_):
                self.fetchUsers();
                completion(.success())
            case .failure(let error):
                print("Error updating permissions, status: \(error ?? 0)")
                completion(.failure(data: error!))
            }
        }
    }
    
}
