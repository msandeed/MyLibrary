//
//  NetflixFlowCoordinator.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 17/04/2024.
//

import Foundation
import SwiftUI
import Combine

class NetflixFlowCoordinator: Navigator, ObservableObject {
    // MARK: -  Coordinator Variables
    @Published var path = NavigationPath()  // Disclaimer: - iOS16 and up
    @Published var sheet: Sheet?
    @Published var fullScreenCover: FullScreenCover?
    @Published var flow: Flow?
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        $path.sink { path in
            print("🧭 NetflixFlowCoordinator path count is: \(path.count)")
        }.store(in: &subscriptions)
    }
    
    // MARK: -  View Building
    func build(page: Page) -> AnyView {
        switch page {
        case .netflixHome:
            return netflixHomeView
        default:
            fatalError("🧭 Page not included in this flow")
        }
    }
    
    func build(flow: Flow) -> AnyView {
        // TODO: Handle elegantly
        EmptyView().asAnyView
    }
    
    func build(sheet: Sheet) -> AnyView {
        // TODO: Handle elegantly
        EmptyView().asAnyView
    }
    
    func build(fullScreenCover: FullScreenCover) -> AnyView {
        // TODO: Handle elegantly
        EmptyView().asAnyView
    }
    
    // MARK: - Lazy Views
    private lazy var netflixHomeView = NetflixHomeView(coordinator: self).asAnyView
}

