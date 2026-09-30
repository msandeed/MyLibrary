//
//  MusicFlowCoordinator.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 30/09/2026.
//

import Foundation
import SwiftUI
import Combine

@available(iOS 27, *)
@MainActor
class MusicFlowCoordinator: @MainActor Navigator, ObservableObject {
    // MARK: -  Coordinator Variables
    @Published var path = NavigationPath()
    @Published var sheet: Sheet?
    @Published var fullScreenCover: FullScreenCover?
    @Published var flow: Flow?
    
    /// Flow-scoped state: the library, playlist and queue screens all read and edit the same
    /// playlists and queue, so the coordinator owns one view model and hands it to each screen.
    private let viewModel: MusicLibraryViewModel
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        viewModel = MusicLibraryViewModel()
        
        $path.sink { path in
            print("🧭 MusicFlowCoordinator path count is: \(path.count)")
        }.store(in: &subscriptions)
    }
}

// MARK: - Building this flow's own views
@available(iOS 27, *)
extension MusicFlowCoordinator {
    func build(page: Page) -> AnyView {
        switch page {
        case .musicLibrary:
            return MusicLibraryView(viewModel: viewModel, coordinator: self).asAnyView
        case .musicPlaylist(let id):
            return MusicPlaylistView(viewModel: viewModel, coordinator: self, playlistID: id).asAnyView
        default:
            fatalError("MusicFlowCoordinator cannot build page: \(page)")
        }
    }
    
    func build(sheet: Sheet) -> AnyView {
        switch sheet {
        case .musicQueue:
            return MusicQueueView(viewModel: viewModel, coordinator: self).asAnyView
        default:
            fatalError("MusicFlowCoordinator cannot build sheet: \(sheet)")
        }
    }
    
    func build(fullScreenCover: FullScreenCover) -> AnyView {
        fatalError("MusicFlowCoordinator cannot build fullScreenCover: \(fullScreenCover)")
    }
    
    func build(flow: Flow) -> AnyView {
        fatalError("MusicFlowCoordinator cannot build flow: \(flow)")
    }
}
