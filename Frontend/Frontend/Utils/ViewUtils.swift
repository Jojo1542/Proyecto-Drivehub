//
//  ViewUtils.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 17/5/24.
//

import Foundation
import SwiftUI

func showDialog(title: String, description: String) {
    let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
    UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
}
