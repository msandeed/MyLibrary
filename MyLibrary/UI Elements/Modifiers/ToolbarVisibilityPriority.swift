//
//  ToolbarVisibilityPriority.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 06/10/2026.
//

import SwiftUI

/// Mirrors `ToolbarItemVisibilityPriority` (iOS 27+) so call sites can declare
/// a priority without availability checks. Before iOS 27 it has no effect.
enum ToolbarPriority {
    case low
    case belowAutomatic
    case automatic
    case aboveAutomatic
    case high

    @available(iOS 27, *)
    var system: ToolbarItemVisibilityPriority {
        switch self {
        case .low: .low
        case .belowAutomatic: ToolbarItemVisibilityPriority(lowerThan: .automatic)
        case .automatic: .automatic
        case .aboveAutomatic: ToolbarItemVisibilityPriority(higherThan: .automatic)
        case .high: .high
        }
    }
}

extension ToolbarContent {
    /// Applies `visibilityPriority(_:)` on iOS 27 and later: when the bar runs out of
    /// space, lower-priority items move into the system overflow menu first.
    @ToolbarContentBuilder
    func visibilityPriorityIfAvailable(_ priority: ToolbarPriority) -> some ToolbarContent {
        if #available(iOS 27, *) {
            visibilityPriority(priority.system)
        } else {
            self
        }
    }
}
