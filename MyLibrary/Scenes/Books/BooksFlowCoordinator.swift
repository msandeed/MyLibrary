//
//  BooksFlowCoordinator.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 06/02/2024.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class BooksFlowCoordinator: @MainActor Navigator, ObservableObject {
    // MARK: -  Coordinator Variables
    @Published var path = NavigationPath()  // Disclaimer: - iOS16 and up
    @Published var sheet: Sheet?
    @Published var fullScreenCover: FullScreenCover?
    @Published var flow: Flow?
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        $path.sink { path in
            print("🧭 BooksFlowCoordinator path count is: \(path.count)")
        }.store(in: &subscriptions)
    }
}

// MARK: - Building this flow's own views
extension BooksFlowCoordinator {
    func build(page: Page) -> AnyView {
        switch page {
        case .books:
            return BooksView(coordinator: self).asAnyView
        case .singleBook(let book):
            return BookView(book: book, coordinator: self).asAnyView
        default:
            fatalError("BooksFlowCoordinator cannot build page: \(page)")
        }
    }

    func build(sheet: Sheet) -> AnyView {
        switch sheet {
        case .books:
            return CoordinatorView(coordinator: BooksFlowCoordinator(), homePage: .books).asAnyView
        default:
            fatalError("BooksFlowCoordinator cannot build sheet: \(sheet)")
        }
    }

    func build(fullScreenCover: FullScreenCover) -> AnyView {
        fatalError("BooksFlowCoordinator cannot build fullScreenCover: \(fullScreenCover)")
    }

    func build(flow: Flow) -> AnyView {
        fatalError("BooksFlowCoordinator cannot build flow: \(flow)")
    }
}
