//
//  DummyViews.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 06/02/2024.
//

import SwiftUI
import Combine

// MARK: - Dummy Views
struct AlienView<CoordinatorType: Coordinator>: @MainActor BaseViewProtocol {
    var viewModel: DummyViewModel = .init()
    var coordinator: CoordinatorType

    @Environment(\.verticalSizeClass) private var verticalSizeClass

    var body: some View {
        if #available(iOS 27.1, *) {
            // The menu is the primary view, so it's the one that stays visible whenever the
            // arrangement collapses (e.g. folded iPhone Duo in landscape). Restricting the
            // split to the horizontal axis shows the icon beside the menu only when the
            // container is wider than tall, and adapts to reserved regions such as the fold.
            ArrangementView {
                menu
            } secondary: {
                icon
            }
            .arrangementViewStyle(.split.axes(.horizontal))
        } else {
            // Before iOS 27.1, approximate the arrangement with size classes:
            // a compact vertical size class means a landscape iPhone.
            HStack(spacing: 0) {
                menu
                if verticalSizeClass == .compact {
                    icon
                }
            }
        }
    }

    var icon: some View {
        Text("👽")
            .font(.system(size: 400))
            .minimumScaleFactor(0.1)
            .lineLimit(1)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder var menu: some View {
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
                
                if #available(iOS 27, *) {
                    Button("🎧 Present Music Flow (iOS 27 only!)") {
                        DummyFlowAnalytics.tappedMusicFlowButton.track()
                        coordinator.present(Flow.music)
                    }
                }
                
                Button("🎨 Present UI Gallery") {
                    DummyFlowAnalytics.tappedUIGalleryFlowButton.track()
                    coordinator.present(Flow.gallery)
                }
            }
        }
        .listStyle(.plain)
    }
}

struct CowView<CoordinatorType: Coordinator>: @MainActor BaseViewProtocol {
    var viewModel: DummyViewModel = .init()
    var coordinator: CoordinatorType
    
    var body: some View {
        VStack(spacing: 12) {
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
            .listStyle(.plain)
        }
        .padding(.top)
    }
}

struct CarView<CoordinatorType: Coordinator>: @MainActor BaseViewProtocol {
    var viewModel: DummyViewModel = .init()
    var coordinator: CoordinatorType
    
    var body: some View {
        VStack(spacing: 12) {
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
            .listStyle(.plain)
        }
        .padding(.top)
    }
}

struct HeartView<CoordinatorType: Coordinator>: @MainActor BaseViewProtocol {
    var viewModel: DummyViewModel = .init()
    var coordinator: CoordinatorType
    
    var body: some View {
        VStack(spacing: 12) {
            Text("❤️")
                .font(.system(size: 100))
                .frame(maxHeight: Constants.height / 8)
            List {
                Button("Dismiss") {
                    coordinator.dismissSheet()
                }
            }
            .listStyle(.plain)
        }
        .padding(.top)
    }
}

struct MonkeyView<CoordinatorType: Coordinator>: @MainActor BaseViewProtocol {
    var viewModel: DummyViewModel = .init()
    var coordinator: CoordinatorType
    
    var body: some View {
        VStack(spacing: 12) {
            Text("🙈")
                .font(.system(size: 100))
                .frame(maxHeight: Constants.height / 8)
            List {
                Button("Dismiss") {
                    coordinator.dismissSheet()
                }
            }
            .listStyle(.plain)
        }
        .padding(.top)
    }
}

struct RocketView<CoordinatorType: Coordinator>: @MainActor BaseViewProtocol {
    var viewModel: DummyViewModel = .init()
    var coordinator: CoordinatorType
    
    var body: some View {
        VStack(spacing: 12) {
            Text("🚀")
                .font(.system(size: 100))
                .frame(maxHeight: Constants.height / 8)
            List {
                Button("Dismiss") {
                    coordinator.dismissFullScreenCover()
                }
            }
            .listStyle(.plain)
        }
        .padding(.top)
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
