//
//  Container.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 28/12/2022.
//

import Foundation
@preconcurrency import Factory
// MARK: - Usecases
class UsecasesContainer: SharedContainer {
    static let booksUsecase = Factory<BooksUseCase> { DefaultBooksUseCase() }
    static let netflixProductsUsecase = Factory<NetflixProductsUseCase> { MockedNetflixProductsUseCase() }
    static let musicLibraryUsecase = Factory<MusicLibraryUseCase> { MockedMusicLibraryUseCase() }
}

// MARK: - Repos
class ServicesContainer: SharedContainer {
    static let networkService = Factory<NetworkService> { DefaultNetworkService() }
}

