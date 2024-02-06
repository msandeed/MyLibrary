//
//  CoordinatorView.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 06/02/2024.
//

import SwiftUI

struct CoordinatorView<CoordinatorType: Coordinator>: View where CoordinatorType: ObservableObject {
    @StateObject private var coordinator: CoordinatorType
    private var homePage: Page
    
    init(coordinator: CoordinatorType, homePage: Page) {
        self._coordinator = StateObject(wrappedValue: coordinator)
        self.homePage = homePage
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(page: homePage)
                .navigationDestination(for: Page.self) { page in
                    coordinator.build(page: page)
                }
                .sheet(item: $coordinator.sheet) { sheet in
                    coordinator.build(sheet: sheet)
                }
                .fullScreenCover(item: $coordinator.fullScreenCover) { cover in
                    coordinator.build(fullScreenCover: cover)
                }
        }
    }
}

#if DEBUG
struct CoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        CoordinatorView(coordinator: ConcreteCoordinator(), homePage: .blue)
    }
}
#endif
