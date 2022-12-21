//
//  Book.swift
//  Books-SwiftUIwMVVM
//
//  Created by Mostafa Sandeed on 28/10/2021.
//

import Foundation

enum Book {
    struct RawBook: Identifiable, Codable {
        var id: Int
        var title: String
        var author: String
    }
    
    struct BookItemViewModel: Identifiable, Codable {
        var id: Int
        var title: String
        var subtitle: String
    }
}
