//
//  Callback.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 13/4/24.
//

import Foundation

enum Callback<U, T> {
    case success(data: U? = nil)
    case failure(data: T? = nil)
}
