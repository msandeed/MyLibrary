//
//  Usecases.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 26/12/2022.
//

import Foundation
import Combine

protocol BaseUseCase {
    var networkService: NetworkService { get }
}

// MARK: - Books
protocol BooksUseCase: BaseUseCase {
    func fetchBooks() -> AnyPublisher<[Book.BookDomain], NetworkError>
}

class DefaultBooksUseCase: BooksUseCase {
    @Injected(ServicesContainer.networkService) internal var networkService
    
    func fetchBooks() -> AnyPublisher<[Book.BookDomain], NetworkError> {
        let metaData = ResourceMetaData(path: Urls.books.rawValue)
        return networkService.executeRequest(for: [Book.BookDTO].self, with: metaData)
    }
}
