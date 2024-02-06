//
//  DummyViews.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 06/02/2024.
//

import SwiftUI
import Combine

// MARK: - Dummy Views
struct BlueView<CoordinatorType: Coordinator>: BaseViewProtocol {
    var viewModel: DummyViewModel
    var coordinator: CoordinatorType
    
    var body: some View {
        VStack {
            Text("BLUE")
                .foregroundStyle(.blue)
            List {
                Button("Red") {
                    coordinator.push(.red)
                }
                Button("Green") {
                    coordinator.push(.green)
                }
                Button("Violet Sheet") {
                    coordinator.present(.violet)
                }
                Button("Gray Full Screen Cover") {
                    coordinator.present(.gray)
                }
                Button("Push Books Flow") {
                    coordinator.present(.books)
                }
            }
        }
    }
}

struct RedView<CoordinatorType: Coordinator>: BaseViewProtocol {
    var viewModel: DummyViewModel
    var coordinator: CoordinatorType
    
    var body: some View {
        VStack {
            Text("Red")
                .foregroundStyle(.red)
            List {
                Button("Green") {
                    coordinator.push(.green)
                }
                Button("Pop") {
                    coordinator.pop()
                }
            }
        }
    }
}

struct GreenView<CoordinatorType: Coordinator>: BaseViewProtocol {
    var viewModel: DummyViewModel
    var coordinator: CoordinatorType
    
    var body: some View {
        VStack {
            Text("Green")
                .foregroundStyle(.green)
            List {
                Button("Pop") {
                    coordinator.pop()
                }
                Button("PopToRoot") {
                    coordinator.popToRoot()
                }
            }
        }
    }
}

struct VioletView<CoordinatorType: Coordinator>: BaseViewProtocol {
    var viewModel: DummyViewModel
    var coordinator: CoordinatorType
    
    var body: some View {
        VStack {
            Text("Violet")
                .foregroundStyle(.purple)
            List {
                Button("Dismiss") {
                    coordinator.dismissSheet()
                }
            }
        }
    }
}

struct YellowView<CoordinatorType: Coordinator>: BaseViewProtocol {
    var viewModel: DummyViewModel
    var coordinator: CoordinatorType
    
    var body: some View {
        VStack {
            Text("Yellow")
                .foregroundStyle(.yellow)
            List {
                Button("Dismiss") {
                    coordinator.dismissSheet()
                }
            }
        }
    }
}

struct GrayView<CoordinatorType: Coordinator>: BaseViewProtocol {
    var viewModel: DummyViewModel
    var coordinator: CoordinatorType
    
    var body: some View {
        VStack {
            Text("Gray")
                .foregroundStyle(.gray)
            List {
                Button("Dismiss") {
                    coordinator.dismissFullScreenCover()
                }
            }
        }
    }
}

// MARK: - Dummy ViewModel
class DummyViewModel: ViewModelType {
    class Input {}
    class Output: ObservableObject {}
    
    let input: Input
    let output: Output
    private(set) var subscriptions: [AnyCancellable] = []

    init() {
        input = .init()
        output = .init()
        
        observeInputs()
        
        // Sometimes have to explicitly call objectWillChange on self for the View to detect output changes
        subscriptions.append(self.output.objectWillChange.receive(on: DispatchQueue.main).sink(receiveValue: { [weak self] _ in
            self?.objectWillChange.send()
        }))
    }
    
    func observeInputs() {}
}

// MARK: - Example Coordinator
class ConcreteCoordinator: Coordinator, ObservableObject {
    // MARK: -  Coordinator Variables
    @Published var path = NavigationPath()  // Disclaimer: - iOS16 and up
    @Published var sheet: Sheet?
    @Published var fullScreenCover: FullScreenCover?
    
    // MARK: -  View Building
    func build(page: Page) -> AnyView {
        switch page {
        case .blue:
            return BlueView(viewModel: .init(), coordinator: self).asAnyView
        case .green:
            return GreenView(viewModel: .init(), coordinator: self).asAnyView
        case .red:
            return RedView(viewModel: .init(), coordinator: self).asAnyView
        default:
            fatalError("Page not included in this flow")
        }
    }
    
    func build(sheet: Sheet) -> AnyView {
        switch sheet {
        case .violet:
            return VioletView(viewModel: .init(), coordinator: self).asAnyView
        case .yellow:
            return YellowView(viewModel: .init(), coordinator: self).asAnyView
        case .books:
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
