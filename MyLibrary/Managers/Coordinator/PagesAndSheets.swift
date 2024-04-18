//
//  PagesAndSheets.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 06/02/2024.
//

import Foundation

enum Page: Hashable {
    case alien, cow, car, books, singleBook(book: Book.BookItemViewModel), netflixHome
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .alien:
            hasher.combine(0)
        case .cow:
            hasher.combine(1)
        case .car:
            hasher.combine(2)
        case .books:
            hasher.combine(3)
        case .singleBook(let book):
            hasher.combine(4)
            hasher.combine(book) // Make sure the BookItemViewModel is also hashable
        case .netflixHome:
            hasher.combine(5)
        }
    }
}

enum Flow: String, Identifiable {
    case dummy, books
    
    var id: String {
        self.rawValue
    }
}

enum Sheet: Identifiable {
    case monkey, heart, books, netflixSingleProduct(product: NetflixProduct.NetflixProductViewModel)
    
    var id: String {
        switch self {
        case .monkey:
            return "monkey"
        case .heart:
            return "heart"
        case .books:
            return "books"
        case .netflixSingleProduct:
            return "netflixSingleProduct"
        }
    }
}

enum FullScreenCover: String, Identifiable {
    case rocket
    
    var id: String {
        self.rawValue
    }
}
