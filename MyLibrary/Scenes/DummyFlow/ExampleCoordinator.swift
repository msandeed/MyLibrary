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
        case .alien:
            print("ConcreteCoordinator: AlienView")
            return AlienView(viewModel: .init(), coordinator: self).asAnyView
        case .car:
            print("ConcreteCoordinator: CarView")
            return CarView(viewModel: .init(), coordinator: self).asAnyView
        case .cow:
            print("ConcreteCoordinator: CowView")
            return CowView(viewModel: .init(), coordinator: self).asAnyView
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
        case .heart:
            return HeartView(viewModel: .init(), coordinator: self).asAnyView
        case .monkey:
            return MonkeyView(viewModel: .init(), coordinator: self).asAnyView
        case .books:
            print("Concrete Coordinator: Books as Sheet")
            return CoordinatorView(coordinator: BooksFlowCoordinator(), homePage: .books).asAnyView
        }
    }
    
    func build(fullScreenCover: FullScreenCover) -> AnyView {
        switch fullScreenCover {
        case .rocket:
            return RocketView(viewModel: .init(), coordinator: self).asAnyView
        }
    }
}
