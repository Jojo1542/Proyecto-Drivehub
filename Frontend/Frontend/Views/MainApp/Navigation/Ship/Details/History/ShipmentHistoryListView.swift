//
//  ShipmentHistoryListView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 20/5/24.
//

import SwiftUI

struct ShipmentHistoryListView: View {
    
    var shipment: ShipmentModel;
    
    var body: some View {
        Section(header: Text("Historial")) {
            ForEach(shipment.statusHistory) { history in
                HStack {
                    VStack(alignment: .leading) {
                        Text(history.status.userFriendlyName)
                            .font(.headline)
                        Text(history.updateDate.formatted())
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        if history.description != nil {
                            Text(history.description!)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
    }
}
