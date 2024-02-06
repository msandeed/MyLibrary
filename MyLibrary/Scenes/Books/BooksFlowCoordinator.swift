//
//  BooksFlowCoordinator.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 06/02/2024.
//

import Foundation
import SwiftUI

class BooksFlowCoordinator: Coordinator, ObservableObject {
    // MARK: -  Coordinator Variables
    @Published var path = NavigationPath()  // Disclaimer: - iOS16 and up
    @Published var sheet: Sheet?
    @Published var fullScreenCover: FullScreenCover?
    
    // MARK: -  View Building
    func build(page: Page) -> AnyView {
        switch page {
        case .books:
            return BooksView(viewModel: .init(), coordinator: self).asAnyView
        case .singleBook(let book):
            return BookView(book: book, viewModel: .init(), coordinator: self).asAnyView
        default:
            fatalError("Page not included in this flow")
        }
    }
    
    func build(sheet: Sheet) -> AnyView {
        EmptyView().asAnyView
    }
    
    func build(fullScreenCover: FullScreenCover) -> AnyView {
        EmptyView().asAnyView
    }
}
