//
//  MusicUsecases.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 30/09/2026.
//

import Foundation
import Combine
@preconcurrency import Factory

// MARK: - Music Library
protocol MusicLibraryUseCase: BaseUseCase {
    func fetchPlaylists() -> AnyPublisher<[MusicLibrary.PlaylistDomain], NetworkError>
}

class DefaultMusicLibraryUseCase: MusicLibraryUseCase {
    @Injected(ServicesContainer.networkService) internal var networkService
    
    func fetchPlaylists() -> AnyPublisher<[MusicLibrary.PlaylistDomain], NetworkError> {
        // Replace with remote fetching logic
        return CurrentValueSubject(previewMusicPlaylists).map { $0.toDomain }.eraseToAnyPublisher()
    }
}
