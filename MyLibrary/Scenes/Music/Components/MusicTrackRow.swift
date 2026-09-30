//
//  MusicTrackRow.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 30/09/2026.
//

import SwiftUI

struct MusicTrackRow: View {
    let track: MusicLibrary.TrackViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(track.title)
                    .font(.body)
                    .lineLimit(1)
                Text(track.artist)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            Spacer()
            Text(track.formattedDuration)
                .font(.subheadline)
                .monospacedDigit()
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        // Opaque background so the row covers its swipe actions until revealed.
        .background(.background)
        .contentShape(.rect)
    }
}

#Preview {
    MusicTrackRow(track: .init(title: "Blue Smoke", artist: "Oscar Vale Trio", durationInSeconds: 367))
}
