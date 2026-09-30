//
//  LiquidGlass.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 30/09/2026.
//

import SwiftUI

extension View {
    @ViewBuilder func glassButtonStyleIfAvailable() -> some View {
        if #available(iOS 26, *) {
            self.buttonStyle(.glass)
        } else {
            self.buttonStyle(.bordered)
        }
    }
}
