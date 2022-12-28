//
//  BooksUseCase.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 26/12/2022.
//

import Foundation
import Combine

protocol BooksUseCase: BaseUseCase {
    func fetchBooks() -> AnyPublisher<[Book.RawBook], NetworkError>
}

class DefaultBooksUseCase: BooksUseCase {
    @Injected(ServicesContainer.networkService) internal var networkService
    
    func fetchBooks() -> AnyPublisher<[Book.RawBook], NetworkError> {
        let metaData = ResourceMetaData(path: Urls.books.rawValue)
        return DefaultNetworkService().fetchData(for: [Book.RawBook].self, with: metaData)
    }
}
