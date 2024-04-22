//
//  BackendDomain.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 12/4/24.
//

import Foundation
import RetroSwift

class BackendDomain: Domain {
    override init(transport: any HttpTransport) {
        super.init(transport: transport)
        transport.setConfiguration(scheme: "http", host: "192.168.1.49", sharedHeaders: nil)
    }
}
