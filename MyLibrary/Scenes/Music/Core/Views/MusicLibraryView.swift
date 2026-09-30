//
//  MusicLibraryView.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 30/09/2026.
//

import SwiftUI

/// Grid of playlists. Long-press and drag a tile to reorder the library (iOS 27 `reorderable()`).
@available(iOS 27, *)
struct MusicLibraryView<CoordinatorType: Coordinator>: @MainActor BaseViewProtocol {
    @ObservedObject var viewModel: MusicLibraryViewModel
    var coordinator: CoordinatorType
    
    private let columns = [GridItem(.adaptive(minimum: 150), spacing: 16)]
    
    var body: some View {
        ScrollView {
            Text("Grid of playlists. Long-press and drag a tile to reorder (iOS 27 `reorderable()`).")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.output.playlists) { playlist in
                    Button {
                        coordinator.push(.musicPlaylist(id: playlist.id))
                    } label: {
                        MusicPlaylistTile(playlist: playlist)
                    }
                    .buttonStyle(.plain)
                }
                .reorderable()
            }
            .reorderContainer(for: MusicLibrary.PlaylistViewModel.self) { difference in
                viewModel.input.movePlaylists.send(difference)
            }
            .padding()
        }
        .navigationTitle("Library")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    coordinator.present(.musicQueue)
                } label: {
                    Label("Up Next", systemImage: "list.bullet")
                }
                .badge(viewModel.output.queue.count)
            }
        }
    }
}

@available(iOS 27, *)
#Preview {
    CoordinatorView(coordinator: MusicFlowCoordinator(), homePage: .musicLibrary)
}
