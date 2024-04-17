//
//  Constants.swift
//  DraftSwiftUI
//
//  Created by Mostafa Sandeed on 21/01/2024.
//

import Foundation
import SwiftUI

struct Constants {
    //Screen dimensions
    static let height = UIScreen.main.bounds.height
    static let width = UIScreen.main.bounds.width
    static var isSmallScreen: Bool {
        width <= 375
    }
}

struct Padding {
    static let micro = 4.0
    static let mini = 6.0
    static let small = 8.0
    static let base = 10.0
    static let mid = 12.0
    static let medium = 15.0
    static let large = 20.0
    static let xLarge = 24.0
    static let massive = 40.0
}

struct Radius {
    static let micro = 2.0
    static let small = 5.0
    static let base = 10.0
    static let mid  = 12.0
    static let medium = 15.0
    static let large = 20.0
    static let larger = 25.0
    static let huge = 40.0
    static let massive = 64.0
}

extension Color {
    ///Enables creation of Color instance from its hex code
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
///Gets the hex code string for this Color
    func hexString() -> String {
        let components = self.cgColor?.components
        let r: CGFloat = components?.count ?? 0 > 0 ? components![0] : 0.0
        let g: CGFloat = components?.count ?? 0 > 1 ? components![1] : 0.0
        let b: CGFloat = components?.count ?? 0 > 2 ? components![2] : 0.0
        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return hexString
    }
}

extension Color {
    static let netflixBlack = Color("NetflixBlack")
    static let netflixWhite = Color("NetflixWhite")
    static let netflixRed = Color("NetflixRed")
    static let netflixDarkRed = Color("NetflixDarkRed")
    static let netflixLightGray = Color("NetflixLightGray")
    static let netflixDarkGray = Color("NetflixDarkGray")
}
