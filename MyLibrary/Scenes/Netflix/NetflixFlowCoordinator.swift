//
//  NetflixFlowCoordinator.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 17/04/2024.
//

import Foundation
import SwiftUI
import Combine

class NetflixFlowCoordinator: Navigator, ObservableObject {
    // MARK: -  Coordinator Variables
    @Published var path = NavigationPath()  // Disclaimer: - iOS16 and up
    @Published var sheet: Sheet?
    @Published var fullScreenCover: FullScreenCover?
    @Published var flow: Flow?
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        $path.sink { path in
            print("🧭 NetflixFlowCoordinator path count is: \(path.count)")
        }.store(in: &subscriptions)
    }
}

