//
//  Coordinator.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 06/02/2024.
//

import Foundation
import SwiftUI
import Combine

protocol Coordinator: AnyObject {
    var path: NavigationPath { get set }
    var sheet: Sheet? { get set }
    var fullScreenCover: FullScreenCover? { get set }
    var flow: Flow? { get set }
    var objectWillChange: ObservableObjectPublisher { get }
    
    func push(_ page: Page)
    func present(_ sheet: Sheet)
    func present(_ fullscreenCover: FullScreenCover)
    func present(_ flow: Flow)
    func pop()
    func popToRoot()
    func dismissSheet()
    func dismissFullScreenCover()
    func dismissFlow()
}

protocol Navigator: Coordinator {
    func build(page: Page) -> AnyView
    func build(flow: Flow) -> AnyView
    func build(sheet: Sheet) -> AnyView
    func build(fullScreenCover: FullScreenCover) -> AnyView
}

// MARK: - Managing flow elements
extension Navigator {
    func push(_ page: Page) {
        print("🧭 Appending page: \(page) to stack")
        path.append(page)
        objectWillChange.send()
    }
    
    func present(_ sheet: Sheet) {
        print("🧭 Presenting Sheet \(sheet)")
        self.sheet = sheet
        objectWillChange.send()
    }
    
    func present(_ fullscreenCover: FullScreenCover) {
        print("🧭 Presenting FullScreenCover \(fullscreenCover)")
        self.fullScreenCover = fullscreenCover
        objectWillChange.send()
    }
    
    func present(_ flow: Flow) {
        print("🧭 Presenting flow: \(flow)")
        self.flow = flow
        objectWillChange.send()
    }
    
    func pop() {
        print("🧭 Popping")
        path.removeLast()
        objectWillChange.send()
    }
    
    func popToRoot() {
        print("🧭 Popping To Root")
        path.removeLast(path.count)
        objectWillChange.send()
    }
    
    func dismissSheet() {
        print("🧭 Dismissing Sheet")
        sheet = nil
        objectWillChange.send()
    }
    
    func dismissFlow() {
        print("🧭 Dismissing Flow")
        flow = nil
        objectWillChange.send()
    }
    
    func dismissFullScreenCover() {
        print("🧭 Dismissing FullScreenCover")
        fullScreenCover = nil
        objectWillChange.send()
    }
}

// MARK: - Building SwiftUI Views
extension Navigator {
    func build(page: Page) -> AnyView {
        switch page {
        case .alien:
            return AlienView(coordinator: self).asAnyView
        case .car:
            return CarView(coordinator: self).asAnyView
        case .cow:
            return CowView(coordinator: self).asAnyView
        case .books:
            return BooksView(coordinator: self).asAnyView
        case .singleBook(let book):
            return BookView(book: book, coordinator: self).asAnyView
        case .netflixHome:
            return NetflixHomeView(coordinator: self).asAnyView
        case .gallery:
            return Demo().asAnyView
        }
    }
    
    func build(flow: Flow) -> AnyView {
        let coordinatedFlow: AnyView = switch flow {
        case .books:
            CoordinatorView(coordinator: BooksFlowCoordinator(), homePage: .books).asAnyView
        case .dummy:
            CoordinatorView(coordinator: ExampleCoordinator(), homePage: .alien).asAnyView
        case .netflix:
            CoordinatorView(coordinator: NetflixFlowCoordinator(), homePage: .netflixHome).asAnyView
        case .gallery:
            CoordinatorView(coordinator: ExampleCoordinator(), homePage: .gallery).asAnyView
        }
        
        return ZStack(alignment: .bottom) {
            coordinatedFlow
            HStack {
                Spacer()
                Image(systemName: "arrow.down.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .onTapGesture {
                        self.dismissFlow()
                    }
            }
            .padding()
        }
        .asAnyView
    }
    
    func build(sheet: Sheet) -> AnyView {
        switch sheet {
        case .heart:
            return HeartView(coordinator: self).asAnyView
        case .monkey:
            return MonkeyView(coordinator: self).asAnyView
        case .books:
            return CoordinatorView(coordinator: BooksFlowCoordinator(), homePage: .books).asAnyView
        case .netflixProduct(product: let product):
            return NetflixProductView(product: product).asAnyView
        }
    }
    
    func build(fullScreenCover: FullScreenCover) -> AnyView {
        switch fullScreenCover {
        case .rocket:
            return RocketView(viewModel: .init(), coordinator: self).asAnyView
        }
    }
}

extension View {
    /// Wraps any given view in a type-erased container `AnyView`.
    var asAnyView: AnyView {
        .init(self)
    }
}
