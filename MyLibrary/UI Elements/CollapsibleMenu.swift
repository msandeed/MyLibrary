//
//  CollapsibleMenu.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 28/04/2024.
//

import SwiftUI

struct CollapsibleMenuItem: Hashable {
    let title: String
    let action: () -> Void
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    
    static func == (lhs: CollapsibleMenuItem, rhs: CollapsibleMenuItem) -> Bool {
        return lhs.title == rhs.title
    }
}

struct CollapsibleMenu: View {
    let items: [CollapsibleMenuItem]
    @State var itemsShown: Bool = false
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .rotationEffect(.degrees(itemsShown ? 45 : 0))
                .onTapGesture {
                    withAnimation(.linear(duration: 0.25)) {
                        itemsShown.toggle()
                    }
                }
            if itemsShown {
                VStack {
                    ForEach(items, id: \.self) { item in
                        Text(item.title)
                            .padding(.vertical, 2)
                            .padding(.horizontal, 8)
                            .foregroundStyle(Color.white)
                            .background(.black)
                            .cornerRadius(4)
                            .onTapGesture {
                                item.action()
                            }
                            .opacity(itemsShown ? 1 : 0)
                            .scaleEffect(itemsShown ? 1 : 0.1)
                    }
                }
            }
        }
    }
}

#Preview {
    CollapsibleMenu(items: [.init(title: "Item 1", action: { print("Item 1 pressed!") }),
                            .init(title: "Item 2", action: { print("Item 2 pressed!") }),
                            .init(title: "Item 3", action: { print("Item 3 pressed!") }),
                            .init(title: "Item 4", action: { print("Item 4 pressed!") }),
                            .init(title: "Item 5", action: { print("Item 5 pressed!") })])
}
