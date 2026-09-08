//
//  NetflixFlowCoordinator.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 17/04/2024.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class NetflixFlowCoordinator: @MainActor Navigator, ObservableObject {
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
}

// MARK: - Building this flow's own views
extension NetflixFlowCoordinator {
    func build(page: Page) -> AnyView {
        switch page {
        case .netflixHome:
            return NetflixHomeView(coordinator: self).asAnyView
        default:
            fatalError("NetflixFlowCoordinator cannot build page: \(page)")
        }
    }

    func build(sheet: Sheet) -> AnyView {
        switch sheet {
        case .netflixProduct(let product):
            return NetflixProductView(product: product).asAnyView
        default:
            fatalError("NetflixFlowCoordinator cannot build sheet: \(sheet)")
        }
    }

    func build(fullScreenCover: FullScreenCover) -> AnyView {
        fatalError("NetflixFlowCoordinator cannot build fullScreenCover: \(fullScreenCover)")
    }

    func build(flow: Flow) -> AnyView {
        fatalError("NetflixFlowCoordinator cannot build flow: \(flow)")
    }
}

