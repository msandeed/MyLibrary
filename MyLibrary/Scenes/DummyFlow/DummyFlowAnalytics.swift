//
//  DummyFlowAnalytics.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 27/08/2024.
//

import Foundation

enum DummyFlowAnalytics: AnalyticEvent {
    case tappedCowButton
    case tappedCarButton
    case tappedScreenRecorderButton
    case tappedSheetButton
    case tappedFullScreenCoverButton
    case tappedBooksFlowButton
    case tappedNetflixFlowButton
    case tappedUIGalleryFlowButton
    // Add others...
    
    var providers: [AnalyticsProvider.Type] {
        AnalyticsKit.allProviders
    }
    
    var name: String {
        switch self {
        case .tappedCowButton:
            return "tapped_Cow_Button"
        case .tappedCarButton:
            return "tapped_Car_Button"
        case .tappedScreenRecorderButton:
            return "tapped_ScreenRecorder_Button"
        case .tappedSheetButton:
            return "tapped_Sheet_Button"
        case .tappedFullScreenCoverButton:
            return "tapped_FullScreenCover_Button"
        case .tappedBooksFlowButton:
            return "tapped_BooksFlow_Button"
        case .tappedNetflixFlowButton:
            return "tapped_NetflixFlow_Button"
        case .tappedUIGalleryFlowButton:
            return "tapped_UIGalleryFlow_Button"
        }
    }
    
    var id: String? { nil }
    
    var properties: AnalyticsKit.Properties? {
        return nil
    }
}
