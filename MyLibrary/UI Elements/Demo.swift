//
//  Demo.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 24/04/2024.
//

import SwiftUI

struct Demo: View {
    var body: some View {
        List {
            Section("Flexible Grid") {
                VStack {
                    FlexibleGrid(items: ["person", "person2", "person3", "person4", "person5"]
                                 , availableWidth: 250.0, backgroundColor: .yellow)
                    FlexibleGrid(items: ["person", "person2", "person3", "person4"]
                                 , availableWidth: 250.0)
                    FlexibleGrid(items: ["person", "person2", "person3"]
                                 , availableWidth: 250.0, backgroundColor: .red)
                    FlexibleGrid(items: ["person", "person2"]
                                 , availableWidth: 250.0)
                    FlexibleGrid(items: ["person"]
                                 , availableWidth: 250.0, backgroundColor: .netflixLightGray)
                }
            }
            
            Section("Small Headshots") {
                HStack {
                    HeadshotView(imageName: "person")
                    HeadshotView(imageName: "person2")
                    HeadshotView(imageName: "person4")
                }
            }
            
            Section("Large Headshots") {
                HStack {
                    HeadshotView(imageName: "person2", diameter: 100, background: .netflixBlack, isBlurred: false)
                    HeadshotView(imageName: "person3", diameter: 100, background: .netflixRed, isBlurred: false)
                    HeadshotView(imageName: "person5", diameter: 100, background: .netflixDarkRed, isBlurred: false)
                }
            }
            
            Section("Collapsible Menu") {
                CollapsibleMenu(items: [.init(title: "Item 1", action: { print("Item 1 pressed!") }),
                                        .init(title: "Item 2", action: { print("Item 2 pressed!") }),
                                        .init(title: "Item 3", action: { print("Item 3 pressed!") }),
                                        .init(title: "Item 4", action: { print("Item 4 pressed!") }),
                                        .init(title: "Item 5", action: { print("Item 5 pressed!") })])
            }
            
            Section("Contact Cards") {
                VStack(alignment: .leading, spacing: 0) {
                    ContactCard(style: .compressed, title: "Someone", subtitle: "subtitle", isSelected: .constant(false))
                    ContactCard(style: .selectable, title: "Someone", subtitle: "subtitle", isSelected: .constant(false))
                    ContactCard(style: .compressed, title: "Someone", isSelected: .constant(false))
                }
            }
        }
    }
}

#Preview {
    Demo()
}
