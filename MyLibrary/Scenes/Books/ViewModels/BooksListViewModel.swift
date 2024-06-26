//
//  BooksListViewModel.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 28/10/2021.
//

import Foundation
import Combine

enum ViewState {    // Currently not used but comes in handy for more complex scenarios
    case idle
    case loading
    case loaded
    case error
}

class BooksListViewModel: ViewModelType {
// MARK: - Inputs and Outputs
    class Input {
        fileprivate(set) var fetchTrigger = PassthroughSubject<Void, Never>()
    }
    
    class Output: ObservableObject {
        @Published fileprivate(set) var viewState: ViewState?   // Currently not used but comes in handy for more complex scenarios
        @Published fileprivate(set) var books: [Book.BookItemViewModel] = []
    }
    
// MARK: - Protocol Conformance
    let input: Input
    let output: Output
    private(set) var subscriptions: [AnyCancellable] = []
    
// MARK: - Private properties
    @Injected(UsecasesContainer.booksUsecase) private var booksUseCase
    
// MARK: - Lifecycle
    init() {
        input = .init()
        output = .init()
        
        observeInputs()
        
        // Sometimes have to explicitly call objectWillChange on self for the View to detect output changes
        subscriptions.append(self.output.objectWillChange.receive(on: DispatchQueue.main).sink(receiveValue: { [weak self] _ in
            self?.objectWillChange.send()
        }))
        
        fetchBooks()
    }
    
// MARK: - Binding
    func observeInputs() {
        input.fetchTrigger.sink { [weak self] _ in
            guard let self = self else { return }
            self.fetchBooks()
        }.store(in: &subscriptions)
    }
    
// MARK: - Functions
    private func fetchBooks() {
        booksUseCase.fetchBooks()
            .sink { (completion) in
                switch completion {
                case .finished:
                    print("✅ Books Retrieved Successfully")
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
            } receiveValue: { (books) in
                let viewModels = books.map {
                    Book.BookItemViewModel(id: $0.id,
                                           title: $0.title.trimmingCharacters(in: .whitespaces),
                                           subtitle: $0.author)
                }
                self.output.books = viewModels
            }
            .store(in: &subscriptions)
    }
}
