//
//  DummyViews.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 06/02/2024.
//

import SwiftUI
import Combine

// MARK: - Shared Layout
/// Lays out a dummy view's menu alongside its emoji icon.
/// The menu is always visible; the icon appears beside it only in landscape.
struct EmojiMenuLayout<Menu: View>: View {
    let emoji: String
    @ViewBuilder var menu: Menu

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

    private var icon: some View {
        Text(emoji)
            .font(.system(size: 400))
            .minimumScaleFactor(0.1)
            .lineLimit(1)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

/// Shows a dummy view's emoji with a row of buttons below it.
struct EmojiButtonsLayout<Buttons: View>: View {
    let emoji: String
    @ViewBuilder var buttons: Buttons

    var body: some View {
        if #available(iOS 27.1, *) {
            // Per Apple's "Preparing your app for iPhone Duo", the overlay arrangement layers the
            // primary view (buttons) over the secondary view (emoji) when there's no active fold,
            // and when the device is partially open it places the primary in the bottom/trailing
            // part of the display and the secondary in the top/leading part. The positioning is
            // done by ArrangementView itself; this code only picks the style and the roles.
            ArrangementView {
                buttonRow
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            } secondary: {
                icon
            }
            .arrangementViewStyle(.overlay)
        } else {
            VStack(spacing: 0) {
                icon
                buttonRow
            }
        }
    }

    /// Fills whatever region it's given and scales the emoji to fit.
    private var icon: some View {
        Text(emoji)
            .font(.system(size: 400))
            .minimumScaleFactor(0.1)
            .lineLimit(1)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var buttonRow: some View {
        HStack(spacing: 12) {
            buttons
        }
        .glassButtonStyleIfAvailable()
        .controlSize(.large)
        .padding()
    }
}

// MARK: - Dummy Views
struct AlienView<CoordinatorType: Coordinator>: @MainActor BaseViewProtocol {
    var viewModel: DummyViewModel = .init()
    var coordinator: CoordinatorType

    var body: some View {
        EmojiMenuLayout(emoji: "👽") {
            menu
        }
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
    @State var showAlert: Bool = false
    @State var alertTitle: String = ""
    
    var body: some View {
        EmojiButtonsLayout(emoji: "🐄") {
            Button("🚙 Page") {
                coordinator.push(.car)
            }
            Button("Pop") {
                coordinator.pop()
            }
        }
        .toolbar {
            // Priorities only take effect on iOS 27+: when space runs out, items move into
            // the overflow menu from lowest priority up. Older versions show every item.
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    alertTitle = "Search to be added"
                    showAlert = true
                } label: {
                    Label("Search", systemImage: "magnifyingglass")
                }
            }
            .visibilityPriorityIfAvailable(.high)

            ToolbarItem(placement: .topBarLeading) {
                toolbarButton("Filter", systemImage: "line.3.horizontal.decrease")
            }
            .visibilityPriorityIfAvailable(.automatic)

            ToolbarItem(placement: .topBarLeading) {
                toolbarButton("Sort", systemImage: "arrow.up.arrow.down")
            }
            .visibilityPriorityIfAvailable(.low)

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    alertTitle = "Info to be added"
                    showAlert = true
                } label: {
                    Label("Info", systemImage: "person")
                }
            }
            .visibilityPriorityIfAvailable(.high)

            ToolbarItem(placement: .topBarTrailing) {
                toolbarButton("Favorite", systemImage: "heart")
            }
            .visibilityPriorityIfAvailable(.aboveAutomatic)

            ToolbarItem(placement: .topBarTrailing) {
                toolbarButton("Share", systemImage: "square.and.arrow.up")
            }
            .visibilityPriorityIfAvailable(.automatic)

            ToolbarItem(placement: .topBarTrailing) {
                toolbarButton("Edit", systemImage: "pencil")
            }
            .visibilityPriorityIfAvailable(.belowAutomatic)

            ToolbarItem(placement: .topBarTrailing) {
                toolbarButton("Settings", systemImage: "gear")
            }
            .visibilityPriorityIfAvailable(.low)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), dismissButton: .default(Text("OK")))
        }
    }

    /// A toolbar button with both a title and an icon, so the system can show the icon
    /// in the bar and the title in the overflow menu.
    private func toolbarButton(_ title: String, systemImage: String) -> some View {
        Button {
            alertTitle = "\(title) to be added"
            showAlert = true
        } label: {
            Label(title, systemImage: systemImage)
        }
    }
}

struct CarView<CoordinatorType: Coordinator>: @MainActor BaseViewProtocol {
    var viewModel: DummyViewModel = .init()
    var coordinator: CoordinatorType
    
    var body: some View {
        EmojiButtonsLayout(emoji: "🚙") {
            Button("Pop") {
                coordinator.pop()
            }
            Button("PopToRoot") {
                coordinator.popToRoot()
            }
        }
    }
}

struct HeartView<CoordinatorType: Coordinator>: @MainActor BaseViewProtocol {
    var viewModel: DummyViewModel = .init()
    var coordinator: CoordinatorType
    
    var body: some View {
        EmojiButtonsLayout(emoji: "❤️") {
            Button("Dismiss") {
                coordinator.dismissSheet()
            }
        }
    }
}

struct RocketView<CoordinatorType: Coordinator>: @MainActor BaseViewProtocol {
    var viewModel: DummyViewModel = .init()
    var coordinator: CoordinatorType
    
    var body: some View {
        EmojiButtonsLayout(emoji: "🚀") {
            Button("Dismiss") {
                coordinator.dismissFullScreenCover()
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
