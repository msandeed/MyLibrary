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
    
    func fetchBooks() -> AnyPublisher<[Book.RawBook], NetworkError> {
        return CurrentValueSubject(previewBooks).eraseToAnyPublisher()  // TODO: Is CurrentValueSubject the best option here?
    }
}
