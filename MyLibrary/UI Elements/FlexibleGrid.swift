//
//  FlexibleGrid.swift
//  Customizer
//
//  Created by Mostafa Sandeed on 14/01/2024.
//

import Foundation
import SwiftUI

struct FlexibleGrid: View {
    var items: [String]
    var availableWidth: CGFloat
    var backgroundColor: Color
    
    var columns: Array<GridItem>
    
    init(items: [String], availableWidth: CGFloat, backgroundColor: Color = Color.green) {
        self.items = items
        self.availableWidth = availableWidth
        self.backgroundColor = backgroundColor
        
        var numberOfColumns: Int
        if items.count < 4 {
            numberOfColumns = items.count
        } else if items.count == 4 {
            numberOfColumns = 2
        } else {
            numberOfColumns = 3
        }
        columns = Array(repeating: GridItem(.flexible()),
                        count: numberOfColumns)
    }
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(Array(items.enumerated()), id: \.element) { (index, item) in
                Image(item)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: availableWidth / 2)
                    .clipShape(Circle())
                    .offset(x: shouldOffsetItemAtIndex(index) ? availableWidth / 6 : 0)
            }
        }
        .padding(5)
        .background(backgroundColor)
        .cornerRadius(10.0)
        .padding(10)
    }
    
    private func shouldOffsetItemAtIndex(_ index: Int) -> Bool {
        items.count == 5 && (index == items.count - 1 || index == items.count - 2)
    }
}

struct FlexibleGrid_Previews: PreviewProvider {
    static var previews: some View {
        FlexibleGrid(items: ["person", "person2", "person3", "person4", "person5"]
                      , availableWidth: 250.0)
    }
}
