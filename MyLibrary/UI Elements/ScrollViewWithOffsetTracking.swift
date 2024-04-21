//
//  ScrollViewWithOffsetTracking.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 21/04/2024.
//

import SwiftUI

struct ScrollViewWithOffsetTracking<Content: View>: View {
    @ViewBuilder var content: () -> Content
    
    var onOffsetChange: (CGFloat) -> Void
    var isIndicatorHidden: Bool = true
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        
            ScrollView(.vertical) {
                content()
                    .background(GeometryReader {
                        Color.clear.preference(key: ScrollOffsetPreferenceKey.self,
                                               value: -$0.frame(in: .named("scroll")).origin.y)
                    })
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) {
                        onOffsetChange($0)
                    }
            }
            .coordinateSpace(name: "scroll")
            .scrollIndicators(isIndicatorHidden ? .hidden : .visible)
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}
