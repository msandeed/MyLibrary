//
//  ThemedGroupBox.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 20/05/2024.
//

import Foundation
import SwiftUI

/*
 Usage: .groupBoxStyle(.themed)
*/

struct ThemedGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
                .foregroundStyle(Color.netflixRed)
                .bold()
            configuration.content
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

extension GroupBoxStyle where Self == ThemedGroupBoxStyle {
    static var themed : ThemedGroupBoxStyle { .init() }
}
