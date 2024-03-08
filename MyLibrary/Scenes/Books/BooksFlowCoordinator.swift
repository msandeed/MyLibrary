//
//  BooksFlowCoordinator.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 06/02/2024.
//

import Foundation
import SwiftUI
import Combine

class BooksFlowCoordinator: Navigator, ObservableObject {
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
    
    // MARK: -  View Building
    func build(page: Page) -> AnyView {
        switch page {
        case .books:
            print("🧭 BooksFlowCoordinator: BooksView")
            return booksView
        case .singleBook(let book):
            print("🧭 BooksFlowCoordinator: BookView")
            return BookView(book: book, coordinator: self).asAnyView
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
    private lazy var booksView = BooksView(coordinator: self).asAnyView
}
