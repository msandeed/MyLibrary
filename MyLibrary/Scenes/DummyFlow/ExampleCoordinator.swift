//
//  ExampleCoordinator.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 07/02/2024.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class ExampleCoordinator: @MainActor Navigator, ObservableObject {
    // MARK: -  Coordinator Variables
    @Published var path = NavigationPath()  // Disclaimer: - iOS16 and up
    @Published var sheet: Sheet?
    @Published var fullScreenCover: FullScreenCover?
    @Published var flow: Flow?
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        $path.sink { path in
            print("🧭 ConcreteCoordinator path count is: \(path.count)")
        }.store(in: &subscriptions)
    }
}

// MARK: - Building this flow's own views
extension ExampleCoordinator {
    func build(page: Page) -> AnyView {
        switch page {
        case .alien:
            return AlienView(coordinator: self).asAnyView
        case .car:
            return CarView(coordinator: self).asAnyView
        case .cow:
            return CowView(coordinator: self).asAnyView
        case .gallery:
            return Demo().asAnyView
        default:
            fatalError("ExampleCoordinator cannot build page: \(page)")
        }
    }

    func build(sheet: Sheet) -> AnyView {
        switch sheet {
        case .heart:
            return HeartView(coordinator: self).asAnyView
        case .monkey:
            return MonkeyView(coordinator: self).asAnyView
        default:
            fatalError("ExampleCoordinator cannot build sheet: \(sheet)")
        }
    }

    func build(fullScreenCover: FullScreenCover) -> AnyView {
        switch fullScreenCover {
        case .rocket:
            return RocketView(viewModel: .init(), coordinator: self).asAnyView
        }
    }

    // The one place cross-flow references are legitimate: presenting a *different*
    // flow's coordinator is the whole point of `Flow`/`present(_ flow:)`.
    func build(flow: Flow) -> AnyView {
        switch flow {
        case .dummy:
            return wrapFlow(CoordinatorView(coordinator: ExampleCoordinator(), homePage: .alien).asAnyView)
        case .gallery:
            return wrapFlow(CoordinatorView(coordinator: ExampleCoordinator(), homePage: .gallery).asAnyView)
        case .books:
            return wrapFlow(CoordinatorView(coordinator: BooksFlowCoordinator(), homePage: .books).asAnyView)
        case .netflix:
            return wrapFlow(CoordinatorView(coordinator: NetflixFlowCoordinator(), homePage: .netflixHome).asAnyView)
        }
    }
}
