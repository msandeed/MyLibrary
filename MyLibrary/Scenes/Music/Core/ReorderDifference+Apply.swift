//
//  ReorderDifference+Apply.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 30/09/2026.
//

import SwiftUI

@available(iOS 27, *)
extension ReorderDifference where CollectionID == ReorderableSingleCollectionIdentifier {
    /// Applies a drag-to-reorder result from `.reorderContainer(for:)` to a single collection.
    /// The moved items are pulled out in one pass (keeping their relative order), then re-inserted
    /// either before the destination item or at the end.
    func apply<C>(to collection: inout C)
        where C: RangeReplaceableCollection,
              C.Element: Identifiable,
              C.Element.ID == ItemID
    {
        let moving = Set(sources)
        guard !moving.isEmpty else { return }
        
        var moved: [C.Element] = []
        moved.reserveCapacity(moving.count)
        collection.removeAll { element in
            guard moving.contains(element.id) else { return false }
            moved.append(element)
            return true
        }
        
        switch destination.position {
        case .before(let id):
            let index = collection.firstIndex { $0.id == id } ?? collection.endIndex
            collection.insert(contentsOf: moved, at: index)
        case .end:
            collection.append(contentsOf: moved)
        }
    }
}
