//
//  MusicPlaylistView.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 30/09/2026.
//

import SwiftUI

/// A playlist's tracks in a `ScrollView` + `LazyVStack` (not a `List`).
/// - Drag a row to reorder (iOS 27 `reorderable()`).
/// - Swipe left to remove, swipe right to add to Up Next (iOS 27 `swipeActionsContainer()`).
@available(iOS 27, *)
struct MusicPlaylistView<CoordinatorType: Coordinator>: @MainActor BaseViewProtocol {
    @ObservedObject var viewModel: MusicLibraryViewModel
    var coordinator: CoordinatorType
    let playlistID: UUID
    
    var body: some View {
        if let playlist = viewModel.output.playlist(id: playlistID) {
            ScrollView {
                header(for: playlist)
                
                LazyVStack(spacing: 0) {
                    ForEach(playlist.tracks) { track in
                        MusicTrackRow(track: track)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    viewModel.input.removeTrack.send((playlistID: playlistID, trackID: track.id))
                                } label: {
                                    Label("Remove", systemImage: "trash")
                                }
                            }
                            .swipeActions(edge: .leading) {
                                Button {
                                    viewModel.input.enqueueTrack.send(track)
                                } label: {
                                    Label("Play Next", systemImage: "text.line.first.and.arrowtriangle.forward")
                                }
                                .tint(.indigo)
                            }
                    }
                    .reorderable()
                }
                .reorderContainer(for: MusicLibrary.TrackViewModel.self) { difference in
                    viewModel.input.moveTracks.send((playlistID: playlistID, difference: difference))
                }
            }
            .swipeActionsContainer()
            .navigationTitle(playlist.title)
            .navigationBarTitleDisplayMode(.inline)
        } else {
            ContentUnavailableView("Playlist Not Found", systemImage: "music.note.list")
        }
    }
    
    private func header(for playlist: MusicLibrary.PlaylistViewModel) -> some View {
        VStack(spacing: 12) {
            MusicArtwork(symbol: playlist.symbol, hue: playlist.hue, cornerRadius: 20)
                .frame(width: 200, height: 200)
                .shadow(radius: 12, y: 6)
            Text(playlist.title)
                .font(.title2)
                .bold()
            Text("Drag to reorder · Swipe for actions")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical)
    }
}
