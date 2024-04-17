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
        var ranking: Int? = nil
        
        var toDomain: NetflixProductDomain {
            .init(
                image: self.image,
                title: self.title,
                subtitle: self.subtitle,
                genres: self.genres,
                isNetflixFilm: self.isNetflixFilm,
                isRecentlyAdded: self.isRecentlyAdded,
                ranking: self.ranking
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
        var ranking: Int? = nil
    }
    
    struct NetflixProductViewModel: Identifiable, Hashable {
        let id = UUID()
        let image: String
        let title: String
        let subtitle: String
        var genres: [String] = []
        var isNetflixFilm: Bool = false
        var isRecentlyAdded: Bool = false
        var ranking: Int? = nil
    }
}

extension Array where Element == NetflixProduct.NetflixProductViewModel {
    var onlyTop: [NetflixProduct.NetflixProductViewModel] {
        self.filter { $0.ranking != nil }
    }
    
    var onlyrecents: [NetflixProduct.NetflixProductViewModel] {
        self.filter { $0.isRecentlyAdded }
    }
}
