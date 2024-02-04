//
//  HeadshotView.swift
//  DraftSwiftUI
//
//  Created by Mostafa Sandeed on 21/01/2024.
//

import Foundation
import SwiftUI

struct HeadshotView: View {
    private var imageName: String
    private var diameter: CGFloat
    private var background: Color
    private var foreground: Color?
    private var contentMode: SwiftUI.ContentMode
    private var padding: CGFloat
    private var isBlurred: Bool
    
    init(imageName: String,
         diameter: CGFloat = 48,
         background: Color = Color.gray.opacity(0.2),
         foreground: Color? = nil,
         contentMode: SwiftUI.ContentMode = .fill,
         padding: CGFloat = 8,
         isBlurred: Bool = false) {
        self.imageName = imageName
        self.diameter = diameter
        self.background = background
        self.foreground = foreground
        self.contentMode = contentMode
        self.padding = padding
        self.isBlurred = isBlurred
    }
    
    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: contentMode)
            .frame(width: diameter, height: diameter)
            .background(background)
            .foregroundColor(foreground)
            .overlay(
                isBlurred ? Color.black.opacity(0.6) : Color.clear
            )
            .clipShape(Circle())
            .clipped()
    }
}
