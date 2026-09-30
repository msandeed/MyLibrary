//
//  MusicLibrary.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 30/09/2026.
//

import Foundation

enum MusicLibrary {
    // MARK: - DTOs
    struct TrackDTO: Decodable, DomainConvertible {
        let title: String
        let artist: String
        let durationInSeconds: Int
        
        var toDomain: TrackDomain {
            .init(title: self.title,
                  artist: self.artist,
                  durationInSeconds: self.durationInSeconds)
        }
    }
    
    struct PlaylistDTO: Decodable, DomainConvertible {
        let title: String
        let symbol: String
        let hue: Double
        let tracks: [TrackDTO]
        
        var toDomain: PlaylistDomain {
            .init(title: self.title,
                  symbol: self.symbol,
                  hue: self.hue,
                  tracks: self.tracks.toDomain)
        }
    }
    
    // MARK: - Domain
    struct TrackDomain {
        let title: String
        let artist: String
        let durationInSeconds: Int
    }
    
    struct PlaylistDomain {
        let title: String
        let symbol: String
        let hue: Double
        let tracks: [TrackDomain]
    }
    
    // MARK: - View Models
    struct TrackViewModel: Identifiable, Hashable {
        let id = UUID()
        let title: String
        let artist: String
        let durationInSeconds: Int
        
        var formattedDuration: String {
            Duration.seconds(durationInSeconds).formatted(.time(pattern: .minuteSecond))
        }
        
        /// A fresh copy with its own identity, so the same song can sit in the queue more than once
        /// without breaking `ForEach`/reorder identity.
        var queuedCopy: TrackViewModel {
            .init(title: title, artist: artist, durationInSeconds: durationInSeconds)
        }
    }
    
    struct PlaylistViewModel: Identifiable, Hashable {
        let id = UUID()
        let title: String
        let symbol: String
        let hue: Double
        var tracks: [TrackViewModel]
    }
}
