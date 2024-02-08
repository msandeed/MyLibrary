//
//  ExampleCoordinator.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 07/02/2024.
//

import Foundation
import SwiftUI
import Combine

class ConcreteCoordinator: Coordinator, ObservableObject {
    // MARK: -  Coordinator Variables
    @Published var path = NavigationPath()  // Disclaimer: - iOS16 and up
    @Published var sheet: Sheet?
    @Published var fullScreenCover: FullScreenCover?
    @Published var flow: Flow?
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        $path.sink { path in
            print("ConcreteCoordinator path count is: \(path.count)")
        }.store(in: &subscriptions)
    }
    
    // MARK: -  View Building
    func build(page: Page) -> AnyView {
        switch page {
        case .blue:
            print("ConcreteCoordinator: BlueView")
            return BlueView(viewModel: .init(), coordinator: self).asAnyView
        case .green:
            print("ConcreteCoordinator: GreenView")
            return GreenView(viewModel: .init(), coordinator: self).asAnyView
        case .red:
            print("ConcreteCoordinator: RedView")
            return RedView(viewModel: .init(), coordinator: self).asAnyView
        default:
            fatalError("Page not included in this flow")
        }
    }
    
    func build(flow: Flow) -> AnyView {
        let coordinatedFlow = switch flow {
        case .books:
            CoordinatorView(coordinator: BooksFlowCoordinator(), homePage: .books)
        default:
            fatalError("Cannot push this Flow from ConcreteCoordinator")
        }
        
        return VStack {
            coordinatedFlow
            Button("Back To Home") {
                self.dismissFlow()
            }
        }.asAnyView
    }
    
    func build(sheet: Sheet) -> AnyView {
        switch sheet {
        case .violet:
            return VioletView(viewModel: .init(), coordinator: self).asAnyView
        case .yellow:
            return YellowView(viewModel: .init(), coordinator: self).asAnyView
        case .books:
            print("Concrete Coordinator: Books as Sheet")
            return CoordinatorView(coordinator: BooksFlowCoordinator(), homePage: .books).asAnyView
        }
    }
    
    func build(fullScreenCover: FullScreenCover) -> AnyView {
        switch fullScreenCover {
        case .gray:
            return GrayView(viewModel: .init(), coordinator: self).asAnyView
        }
    }
}
