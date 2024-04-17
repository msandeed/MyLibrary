//
//  Usecases.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 17/04/2024.
//

import Foundation
import Combine

// MARK: - Books
protocol NetflixProductsUseCase: BaseUseCase {
    func fetchProducts() -> AnyPublisher<[NetflixProduct.NetflixProductDomain], NetworkError>
}

class DefaultNetflixProductsUseCase: NetflixProductsUseCase {
    @Injected(ServicesContainer.networkService) internal var networkService
    
    func fetchProducts() -> AnyPublisher<[NetflixProduct.NetflixProductDomain], NetworkError> {
        // Replace with remote fetching logic
        return CurrentValueSubject(previewProducts.shuffled()).map { $0.toDomain }.eraseToAnyPublisher()
    }
}
