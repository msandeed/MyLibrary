//
//  Book.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 28/10/2021.
//

import Foundation
// MARK: - Book
enum Book {
    struct BookDTO: Decodable, DomainConvertible {
        var id: Int
        var title: String
        var author: String
        
        var toDomain: BookDomain {
            .init(id: self.id, title: self.title, author: self.author)
        }
    }
    
    struct BookDomain {
        var id: Int
        var title: String
        var author: String
    }
    
    struct BookItemViewModel: Identifiable {
        var id: Int
        var title: String
        var subtitle: String
    }
}

// MARK: - Post
// Fictional
enum Post {
    struct PostDTO: Decodable, DomainConvertible {
        var id: Int
        var title: String
        var author: String
        
        var toDomain: PostDomain {
            .init(id: self.id, title: self.title, author: self.author)
        }
    }
    
    struct PostDomain {
        var id: Int
        var title: String
        var author: String
    }
    
    struct PostItemViewModel: Identifiable {
        var id: Int
        var title: String
        var subtitle: String
    }
}
