//
//  CoordinatorView.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 06/02/2024.
//

import SwiftUI

struct CoordinatorView<CoordinatorType: Navigator>: View where CoordinatorType: ObservableObject {
    @ObservedObject private var coordinator: CoordinatorType
    @Environment(\.dismissFlowAction) private var dismissFlowAction
    private var homePage: Page
    
    init(coordinator: CoordinatorType, homePage: Page) {
        print("🧭 CoordinatorView initialized with homePage: \(homePage) and coordinator: \(coordinator)")
        self._coordinator = ObservedObject(wrappedValue: coordinator)
        self.homePage = homePage
    }
    
    var body: some View {
        VStack {
            NavigationStack(path: $coordinator.path) {
                coordinator.build(page: homePage)
                    .toolbar {
                        if let dismissFlowAction {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button(action: dismissFlowAction) {
                                    Label("Dismiss Flow", systemImage: "arrow.down")
                                }
                            }
                            .visibilityPriorityIfAvailable(.high)
                        }
                    }
                    .navigationDestination(for: Page.self) { page in
                        coordinator.build(page: page)
                    }
                    .sheet(item: $coordinator.sheet) { sheet in
                        coordinator.build(sheet: sheet)
                    }
                    .fullScreenCover(item: $coordinator.fullScreenCover) { cover in
                        coordinator.build(fullScreenCover: cover)
                    }
                    .fullScreenCover(item: $coordinator.flow) { flow in
                        coordinator.build(flow: flow)
                    }
            }
            // Consumed above; don't leak this flow's dismiss action into its pages or presentations.
            .environment(\.dismissFlowAction, nil)
        }
    }
}

#if DEBUG
struct CoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        CoordinatorView(coordinator: ExampleCoordinator(), homePage: .alien)
    }
}
#endif
