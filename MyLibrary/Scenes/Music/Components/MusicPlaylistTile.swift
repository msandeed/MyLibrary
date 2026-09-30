//
//  MusicPlaylistTile.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 30/09/2026.
//

import SwiftUI

struct MusicPlaylistTile: View {
    let playlist: MusicLibrary.PlaylistViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            MusicArtwork(symbol: playlist.symbol, hue: playlist.hue)
                .aspectRatio(1, contentMode: .fit)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(playlist.title)
                    .font(.headline)
                    .lineLimit(1)
                Text("\(playlist.tracks.count) songs")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(8)
        .background(.fill.quaternary, in: .rect(cornerRadius: 18))
        .contentShape(.rect(cornerRadius: 18))
        // Lifted tile (drag-to-reorder) uses the same rounded card shape instead of a plain rectangle.
        .contentShape(.dragPreview, .rect(cornerRadius: 18))
    }
}

/// Gradient artwork with an SF Symbol, standing in for real album art.
struct MusicArtwork: View {
    let symbol: String
    let hue: Double
    var cornerRadius: CGFloat = 12
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(LinearGradient(colors: [Color(hue: hue, saturation: 0.7, brightness: 0.9),
                                          Color(hue: hue, saturation: 0.9, brightness: 0.45)],
                                 startPoint: .topLeading,
                                 endPoint: .bottomTrailing))
            .overlay {
                Image(systemName: symbol)
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.9))
                    .accessibilityHidden(true)
            }
    }
}

#Preview {
    MusicPlaylistTile(playlist: .init(title: "Deep Focus", symbol: "brain.head.profile", hue: 0.62, tracks: []))
        .frame(width: 170)
        .padding()
}
