//
//  Mocks.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 30/12/2022.
//

import Foundation
import Combine
@preconcurrency import Factory

class MockedBooksUseCase: BooksUseCase {
    @Injected(ServicesContainer.networkService) internal var networkService
    
    func fetchBooks() -> AnyPublisher<[Book.BookDomain], NetworkError> {
        return CurrentValueSubject(previewBooks).map { $0.toDomain }.eraseToAnyPublisher()  // TODO: Is CurrentValueSubject the best option here?
    }
}

class MockedNetflixProductsUseCase: NetflixProductsUseCase {
    @Injected(ServicesContainer.networkService) internal var networkService
    
    func fetchProducts() -> AnyPublisher<[NetflixProduct.NetflixProductDomain], NetworkError> {
        return CurrentValueSubject(previewProducts.shuffled()).map { $0.toDomain }.eraseToAnyPublisher()  // TODO: Is CurrentValueSubject the best option here?
    }
}

class MockedMusicLibraryUseCase: MusicLibraryUseCase {
    @Injected(ServicesContainer.networkService) internal var networkService
    
    func fetchPlaylists() -> AnyPublisher<[MusicLibrary.PlaylistDomain], NetworkError> {
        return CurrentValueSubject(previewMusicPlaylists).map { $0.toDomain }.eraseToAnyPublisher()
    }
}
