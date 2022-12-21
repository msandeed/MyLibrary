//
//  BooksListViewModel.swift
//  Books-SwiftUIwMVVM
//
//  Created by Mostafa Sandeed on 28/10/2021.
//

import Foundation
import Combine

class BooksListViewModel: ObservableObject {
    
    var subscriptions = Set<AnyCancellable>()
    let networkManager = NetworkManager()
    @Published var books = [Book]()
    
    init() {
        NetworkManager().fetchBooks()
            .sink { (completion) in
                switch completion {
                case .finished:
                    print("Books Retrieved Successfully")
                case .failure(let error):
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
                self.books = books
                print("BOOKS: \(self.books)")
            }
            .store(in: &subscriptions)
    }
}
