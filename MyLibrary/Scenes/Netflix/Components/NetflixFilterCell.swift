//
//  NetflixFilterCell.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 16/04/2024.
//

import SwiftUI

struct NetflixFilterCell: View {
    var title: String
    var hasDropdown: Bool
    var isSelected: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            Text(title)
            if hasDropdown {
                Image(systemName: "chevron.down")
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background {
            if isSelected {
                Capsule(style: .circular)
                    .fill(Color.netflixDarkGray)
                    .opacity(isSelected ? 1 : 0)
            } else {
                Capsule(style: .circular)
                    .stroke(lineWidth: 1)
            }
        }
        .foregroundStyle(Color.netflixLightGray)
    }
}

#Preview {
    ZStack {
        Color.netflixBlack.ignoresSafeArea()
        VStack {
            NetflixFilterCell(title: "Movies", 
                              hasDropdown: false,
                              isSelected: true)
            NetflixFilterCell(title: "Documenteries",
                              hasDropdown: true,
                              isSelected: false)
            NetflixFilterCell(title: "Series",
                              hasDropdown: false,
                              isSelected: false)
        }
    }
}
