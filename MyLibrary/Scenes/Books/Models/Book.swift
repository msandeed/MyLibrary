//
//  Book.swift
//  Books-SwiftUIwMVVM
//
//  Created by Mostafa Sandeed on 28/10/2021.
//

import Foundation

struct Book: Identifiable, Codable {
    var id: Int
    var title: String
    var author: String
}

protocol Detailable {
    var treatedTitle: String { get }
    var subtitle: String { get }
}

extension Book: Detailable {
    var treatedTitle: String {
        return title.trimmingCharacters(in: .whitespaces)
    }
    var subtitle: String {
        return self.author
    }
}
