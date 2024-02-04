//
//  Mocks.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 30/12/2022.
//

import Foundation
import Combine

class MockedBooksUseCase: BooksUseCase {
    @Injected(ServicesContainer.networkService) internal var networkService
    
    func fetchBooks() -> AnyPublisher<[Book.BookDomain], NetworkError> {
        return CurrentValueSubject(previewBooks).map { $0.toDomain }.eraseToAnyPublisher()  // TODO: Is CurrentValueSubject the best option here?
    }
}
