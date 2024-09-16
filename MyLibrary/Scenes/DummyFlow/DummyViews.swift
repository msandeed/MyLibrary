//
//  DummyViews.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 06/02/2024.
//

import SwiftUI
import Combine

// MARK: - Dummy Views
struct AlienView<CoordinatorType: Navigator>: BaseViewProtocol {
    var viewModel: DummyViewModel = .init()
    var coordinator: CoordinatorType
    
    var body: some View {
        VStack {
            Text("👽")
                .font(.system(size: 100))
                .frame(maxHeight: Constants.height / 8)
            List {
                Section("Internal Views") {
                    Button("🐄 Page") {
                        DummyFlowAnalytics.tappedCowButton.track()
                        coordinator.push(.cow)
                    }
                    Button("🚙 Page") {
                        DummyFlowAnalytics.tappedCarButton.track()
                        coordinator.push(.car)
                    }
                    Button("📷 Screen Recorder") {
                        DummyFlowAnalytics.tappedCarButton.track()
                        coordinator.push(.car)
                    }
                    Button("❤️ Sheet") {
                        DummyFlowAnalytics.tappedSheetButton.track()
                        coordinator.present(.heart)
                    }
                    Button("🚀 Full Screen Cover") {
                        DummyFlowAnalytics.tappedFullScreenCoverButton.track()
                        coordinator.present(.rocket)
                    }
                }
                
                Section("To Another Flow") {
                    Button("📚 Present Books Flow") {
                        DummyFlowAnalytics.tappedBooksFlowButton.track()
                        coordinator.present(Flow.books)
                    }
                    
                    Button("🎬 Present Netflix Flow") {
                        DummyFlowAnalytics.tappedNetflixFlowButton.track()
                        coordinator.present(Flow.netflix)
                    }
                    
                    Button("🎨 Present UI Gallery") {
                        DummyFlowAnalytics.tappedUIGalleryFlowButton.track()
                        coordinator.present(Flow.gallery)
                    }
                }
            }
        }
    }
}

struct CowView<CoordinatorType: Navigator>: BaseViewProtocol {
    var viewModel: DummyViewModel = .init()
    var coordinator: CoordinatorType
    
    var body: some View {
        VStack {
            Text("🐄")
                .font(.system(size: 100))
                .frame(maxHeight: Constants.height / 8)
            List {
                Button("🚙 Page") {
                    coordinator.push(.car)
                }
                Button("Pop") {
                    coordinator.pop()
                }
            }
        }
    }
}

struct CarView<CoordinatorType: Navigator>: BaseViewProtocol {
    var viewModel: DummyViewModel = .init()
    var coordinator: CoordinatorType
    
    var body: some View {
        VStack {
            Text("🚙")
                .font(.system(size: 100))
                .frame(maxHeight: Constants.height / 8)
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

struct HeartView<CoordinatorType: Navigator>: BaseViewProtocol {
    var viewModel: DummyViewModel = .init()
    var coordinator: CoordinatorType
    
    var body: some View {
        VStack {
            Spacer()
            Text("❤️")
                .font(.system(size: 100))
                .frame(maxHeight: Constants.height / 8)
            List {
                Button("Dismiss") {
                    coordinator.dismissSheet()
                }
            }
        }
    }
}

struct MonkeyView<CoordinatorType: Navigator>: BaseViewProtocol {
    var viewModel: DummyViewModel = .init()
    var coordinator: CoordinatorType
    
    var body: some View {
        VStack {
            Text("🙈")
                .font(.system(size: 100))
                .frame(maxHeight: Constants.height / 8)
            List {
                Button("Dismiss") {
                    coordinator.dismissSheet()
                }
            }
        }
    }
}

struct RocketView<CoordinatorType: Navigator>: BaseViewProtocol {
    var viewModel: DummyViewModel = .init()
    var coordinator: CoordinatorType
    
    var body: some View {
        VStack {
            Text("🚀")
                .font(.system(size: 100))
                .frame(maxHeight: Constants.height / 8)
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
