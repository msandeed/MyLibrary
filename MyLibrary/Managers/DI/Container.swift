//
//  Container.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 28/12/2022.
//

import Foundation
// MARK: - Usecases
class UsecasesContainer: SharedContainer {
    static let booksUsecase = Factory<BooksUseCase> { DefaultBooksUseCase() }
    static let netflixProductsUsecase = Factory<NetflixProductsUseCase> { MockedNetflixProductsUseCase() }
}

// MARK: - Repos
class ServicesContainer: SharedContainer {
    static let networkService = Factory<NetworkService> { DefaultNetworkService() }
}

