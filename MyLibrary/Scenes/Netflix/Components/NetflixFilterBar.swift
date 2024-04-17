//
//  NetflixFilterBar.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 16/04/2024.
//

import SwiftUI

struct FilterItem: Hashable, Equatable {
    let title: String
    let hasDropdown: Bool
    
    static var mockedItems: [FilterItem] {
        [
            .init(title: "Movies", hasDropdown: false),
            .init(title: "Documenteries", hasDropdown: true),
            .init(title: "Series", hasDropdown: false)
        ]
    }
}

struct NetflixFilterBar: View {
    var filterItems: [FilterItem]
    @Binding var selectedItem: FilterItem?
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                if selectedItem != nil {
                    Image(systemName: "xmark")
                        .padding(8)
                        .background {
                            Circle()
                                .stroke(lineWidth: 1)
                        }
                        .foregroundStyle(Color.netflixLightGray)
                        .background(Color.black.opacity(0.001))
                        .onTapGesture {
                            withAnimation {
                                selectedItem = nil
                            }
                        }
                        .transition(AnyTransition.move(edge: .leading))
                        .padding(.leading, 16)
                }
                
                ForEach(filterItems, id: \.self) { item in
                    if selectedItem == nil || item == selectedItem {
                        NetflixFilterCell(title: item.title,
                                          hasDropdown: item.hasDropdown,
                                          isSelected: item == selectedItem)
                        .background(Color.black.opacity(0.001))
                        .onTapGesture {
                            withAnimation {
                                selectedItem = item
                            }
                        }
                        .padding(.leading, (selectedItem == nil) && (item == filterItems.first) ? 16 : 0)
                    }
                }
            }
            .padding(.vertical, 4)
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    ZStack {
        Color.netflixBlack.ignoresSafeArea()
        NetflixFilterBar(filterItems: [
            .init(title: "Movies", hasDropdown: false),
            .init(title: "Documenteries", hasDropdown: true),
            .init(title: "Series", hasDropdown: false)],
                         selectedItem: .constant(nil))
    }
}
