//
//  ExampleCoordinator.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 07/02/2024.
//

import Foundation
import SwiftUI
import Combine

class ExampleCoordinator: Navigator, ObservableObject {
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
    
    // MARK: -  View Building
    func build(page: Page) -> AnyView {
        switch page {
        case .alien:
            print("🧭 ConcreteCoordinator: AlienView")
            return alienView
        case .car:
            print("🧭 ConcreteCoordinator: CarView")
            return carView
        case .cow:
            print("🧭 ConcreteCoordinator: CowView")
            return cowView
        default:
            fatalError("🧭 Page not included in this flow")
        }
    }
    
    func build(flow: Flow) -> AnyView {
        let coordinatedFlow = switch flow {
        case .books:
            CoordinatorView(coordinator: BooksFlowCoordinator(), homePage: .books)
        default:
            fatalError("🧭 Cannot push this Flow from ConcreteCoordinator")
        }
        
        return VStack {
            coordinatedFlow
            Button("🧭 Back To Home") {
                self.dismissFlow()
            }
        }
        .background(.orange)
        .asAnyView
    }
    
    func build(sheet: Sheet) -> AnyView {
        switch sheet {
        case .heart:
            return heartView
        case .monkey:
            return monkeyView
        case .books:
            print("🧭 Concrete Coordinator: Books as Sheet")
            return CoordinatorView(coordinator: BooksFlowCoordinator(), homePage: .books).asAnyView
        }
    }
    
    func build(fullScreenCover: FullScreenCover) -> AnyView {
        switch fullScreenCover {
        case .rocket:
            return RocketView(viewModel: .init(), coordinator: self).asAnyView
        }
    }
    
    // MARK: - Lazy Views
    lazy var alienView = AlienView(coordinator: self).asAnyView
    lazy var carView = CarView(coordinator: self).asAnyView
    lazy var cowView = CowView(coordinator: self).asAnyView
    lazy var heartView = HeartView(coordinator: self).asAnyView
    lazy var monkeyView = MonkeyView(coordinator: self).asAnyView
    lazy var rocketView = RocketView(coordinator: self).asAnyView
}
