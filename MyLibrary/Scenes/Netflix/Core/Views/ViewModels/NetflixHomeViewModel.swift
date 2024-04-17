//
//  NetflixHomeViewModel.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 17/04/2024.
//

import Foundation
import Combine

class NetflixHomeViewModel: ViewModelType {
// MARK: - Inputs and Outputs
    class Input {
        fileprivate(set) var fetchTrigger = PassthroughSubject<Void, Never>()
    }
    
    class Output: ObservableObject {
        @Published fileprivate(set) var products: [NetflixProduct.NetflixProductViewModel] = []
    }
    
// MARK: - Protocol Conformance
    let input: Input
    let output: Output
    private(set) var subscriptions: [AnyCancellable] = []
    
// MARK: - Private properties
    @Injected(UsecasesContainer.netflixProductsUsecase) private var netflixProductsUsecase
    
// MARK: - Lifecycle
    init() {
        input = .init()
        output = .init()
        
        observeInputs()
        
        // Sometimes have to explicitly call objectWillChange on self for the View to detect output changes
        subscriptions.append(self.output.objectWillChange.receive(on: DispatchQueue.main).sink(receiveValue: { [weak self] _ in
            self?.objectWillChange.send()
        }))
        
        fetchProducts()
    }
    
// MARK: - Binding
    func observeInputs() {
        input.fetchTrigger.sink { [weak self] _ in
            guard let self = self else { return }
            self.fetchProducts()
        }.store(in: &subscriptions)
    }
    
// MARK: - Functions
    private func fetchProducts() {
        netflixProductsUsecase.fetchProducts()
            .sink { (completion) in
                switch completion {
                case .finished:
                    print("✅ Netflix Products Retrieved Successfully")
                case .failure(let error):
                    // Some of those could be handled in lower layers.. UseCase or NetworkService. For now, we're bubbling them all up to ViewModel
                    switch error {
                    case .requestError:
                        print("⚠️ Request Error")
                    case .decodingError(error: let decodingError):
                        print("⚠️ Decoding Error: \(decodingError.localizedDescription)")
                    case .serverError(statusCode: let statusCode):
                        print("⚠️ Server Error: \(statusCode)")
                    case .internalError(statusCode: let statusCode):
                        print("⚠️ Internal Error: \(statusCode)")
                    case .noData:
                        print("⚠️ No Data in Response")
                    case .unknown:
                        print("⚠️ Unknown Error")
                    }
                }
            } receiveValue: { (products) in
                let viewModels = products.map {
                    NetflixProduct.NetflixProductViewModel.init(
                        image: $0.image,
                        title: $0.title,
                        subtitle: $0.subtitle,
                        genres: $0.genres,
                        isNetflixFilm: $0.isNetflixFilm,
                        isRecentlyAdded: $0.isRecentlyAdded,
                        ranking: $0.ranking
                    )
                }
                self.output.products = viewModels
            }
            .store(in: &subscriptions)
    }
    
    var topList: [NetflixProduct.NetflixProductViewModel] {
        output.products.onlyTop.sorted { $0.ranking ?? 0 < $1.ranking ?? 0 }
    }
    
    var otherList: [NetflixProduct.NetflixProductViewModel] {
        output.products.filter { !topList.contains($0) }
    }
}
