//
//  MusicLibraryViewModel.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 30/09/2026.
//

import Foundation
import SwiftUI
import Combine
@preconcurrency import Factory

/// Shared by every screen in the Music flow (library, playlist, queue), so a song added
/// to "Up Next" from a playlist shows up in the queue sheet straight away.
@available(iOS 27, *)
class MusicLibraryViewModel: ViewModelType {
    /// What `.reorderContainer(for:)` reports for a single (unsectioned) collection keyed by `UUID`.
    typealias Reorder = ReorderDifference<UUID, ReorderableSingleCollectionIdentifier>
    
// MARK: - Inputs and Outputs
    class Input {
        let fetchTrigger = PassthroughSubject<Void, Never>()
        let movePlaylists = PassthroughSubject<Reorder, Never>()
        let moveTracks = PassthroughSubject<(playlistID: UUID, difference: Reorder), Never>()
        let removeTrack = PassthroughSubject<(playlistID: UUID, trackID: UUID), Never>()
        let enqueueTrack = PassthroughSubject<MusicLibrary.TrackViewModel, Never>()
        let moveQueue = PassthroughSubject<Reorder, Never>()
        let removeFromQueue = PassthroughSubject<UUID, Never>()
    }
    
    class Output: ObservableObject {
        @Published fileprivate(set) var playlists: [MusicLibrary.PlaylistViewModel] = []
        @Published fileprivate(set) var queue: [MusicLibrary.TrackViewModel] = []
        
        func playlist(id: UUID) -> MusicLibrary.PlaylistViewModel? {
            playlists.first { $0.id == id }
        }
    }
    
// MARK: - Protocol Conformance
    let input: Input
    let output: Output
    private(set) var subscriptions: [AnyCancellable] = []
    
// MARK: - Private properties
    @Injected(UsecasesContainer.musicLibraryUsecase) private var musicLibraryUsecase
    
// MARK: - Lifecycle
    init() {
        input = .init()
        output = .init()
        
        observeInputs()
        
        // Sometimes have to explicitly call objectWillChange on self for the View to detect output changes
        subscriptions.append(self.output.objectWillChange.receive(on: DispatchQueue.main).sink(receiveValue: { [weak self] _ in
            self?.objectWillChange.send()
        }))
        
        fetchPlaylists()
    }
    
// MARK: - Binding
    func observeInputs() {
        input.fetchTrigger.sink { [weak self] _ in
            self?.fetchPlaylists()
        }.store(in: &subscriptions)
        
        input.movePlaylists.sink { [weak self] difference in
            guard let self else { return }
            difference.apply(to: &self.output.playlists)
        }.store(in: &subscriptions)
        
        input.moveTracks.sink { [weak self] playlistID, difference in
            guard let self,
                  let index = self.output.playlists.firstIndex(where: { $0.id == playlistID }) else { return }
            difference.apply(to: &self.output.playlists[index].tracks)
        }.store(in: &subscriptions)
        
        input.removeTrack.sink { [weak self] playlistID, trackID in
            guard let self,
                  let index = self.output.playlists.firstIndex(where: { $0.id == playlistID }) else { return }
            self.output.playlists[index].tracks.removeAll { $0.id == trackID }
        }.store(in: &subscriptions)
        
        input.enqueueTrack.sink { [weak self] track in
            self?.output.queue.append(track.queuedCopy)
        }.store(in: &subscriptions)
        
        input.moveQueue.sink { [weak self] difference in
            guard let self else { return }
            difference.apply(to: &self.output.queue)
        }.store(in: &subscriptions)
        
        input.removeFromQueue.sink { [weak self] trackID in
            self?.output.queue.removeAll { $0.id == trackID }
        }.store(in: &subscriptions)
    }
    
// MARK: - Functions
    private func fetchPlaylists() {
        musicLibraryUsecase.fetchPlaylists()
            .sink { (completion) in
                switch completion {
                case .finished:
                    print("✅ Music Playlists Retrieved Successfully")
                case .failure(let error):
                    print("⚠️ Failed to fetch playlists: \(error)")
                }
            } receiveValue: { [weak self] (playlists) in
                self?.output.playlists = playlists.map { playlist in
                    MusicLibrary.PlaylistViewModel(
                        title: playlist.title,
                        symbol: playlist.symbol,
                        hue: playlist.hue,
                        tracks: playlist.tracks.map {
                            MusicLibrary.TrackViewModel(title: $0.title,
                                                        artist: $0.artist,
                                                        durationInSeconds: $0.durationInSeconds)
                        }
                    )
                }
            }
            .store(in: &subscriptions)
    }
}
