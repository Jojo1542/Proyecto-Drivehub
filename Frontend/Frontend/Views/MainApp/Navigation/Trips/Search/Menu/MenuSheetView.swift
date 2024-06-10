//
//  MenuSheetView.swift
//  Frontend
//
//  Created by Jose Antonio Ponce Piñero on 22/5/24.
//

import SwiftUI

struct MenuSheetView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State var offsetY: CGFloat = UIScreen.main.bounds.height * 0.4
    @State var lastDragValue: DragGesture.Value?

    private var sensibility: CGFloat = 0.3
    
    private var positions: [CGFloat] = [
        UIScreen.main.bounds.height * 1.0,
        UIScreen.main.bounds.height * 0.4,
        UIScreen.main.bounds.height * 0.1
    ]

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                VStack {
                    // Upper handle
                    RoundedRectangle(cornerRadius: 2)
                            .fill(Color.secondary)
                            .frame(width: 40, height: 6)
                            .padding(.vertical, 4)
                    
                    // Dejar arriba del todo el rectangulo
                    Spacer()
                    
                    // Menu content
                    TripsMenuView()
                    
                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                // Make it translucid
                .background(colorScheme == .dark ? Color.black.opacity(0.8) : Color.white.opacity(0.8))
                .cornerRadius(20)
                .offset(y: max(0, geometry.size.height - offsetY))
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let totalDrag = value.translation.height * sensibility + (lastDragValue?.translation.height ?? 0)
                            offsetY = clampHeight(to: offsetY - totalDrag, in: geometry.size.height)
                            lastDragValue = value
                        }
                        .onEnded { value in
                            offsetY = closestPosition(to: offsetY, in: geometry.size.height)
                            lastDragValue = nil
                        }
                )
                .animation(.spring(), value: offsetY)
            }
        }
    }

    private func clampHeight(to value: CGFloat, in height: CGFloat) -> CGFloat {
        return max(positions.min() ?? 0, min(positions.max() ?? height, value))
    }

    private func closestPosition(to value: CGFloat, in height: CGFloat) -> CGFloat {
        return positions.min(by: { abs($0 - value) < abs($1 - value) }) ?? value
    }
}
