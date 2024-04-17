//
//  NetflixProduct.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 17/04/2024.
//

import Foundation

enum NetflixProduct {
    struct NetflixProductDTO: Decodable, DomainConvertible {
        let image: String
        let title: String
        let subtitle: String
        var genres: [String] = []
        var isNetflixFilm: Bool = false
        var isRecentlyAdded: Bool = false
        var isTopTen: Bool = false
        
        var toDomain: NetflixProductDomain {
            .init(
                image: self.image,
                title: self.title,
                subtitle: self.subtitle,
                genres: self.genres,
                isNetflixFilm: self.isNetflixFilm,
                isRecentlyAdded: self.isRecentlyAdded,
                isTopTen: self.isTopTen
            )
        }
    }
    
    struct NetflixProductDomain {
        let image: String
        let title: String
        let subtitle: String
        var genres: [String] = []
        var isNetflixFilm: Bool = false
        var isRecentlyAdded: Bool = false
        var isTopTen: Bool = false
    }
    
    struct NetflixProductViewModel: Identifiable, Hashable {
        let id = UUID()
        let image: String
        let title: String
        let subtitle: String
        var genres: [String] = []
        var isNetflixFilm: Bool = false
        var isRecentlyAdded: Bool = false
        var isTopTen: Bool = false
    }
}
