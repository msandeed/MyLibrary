//
//  NetflixCell.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 17/04/2024.
//

import SwiftUI
import Kingfisher

struct NetflixCell: View {
    var content: NetflixProduct.NetflixProductViewModel
    var onTap: () -> Void
    private let height: CGFloat = 140
    
    var body: some View {
        HStack(alignment: .bottom) {
            if let ranking = content.ranking {
                Text(String(ranking))
                    .font(.system(size: 100, weight: .medium, design: .serif))
                    .lineLimit(1)
                    .offset(x: 20, y: 16)
            }
            ZStack(alignment: .bottom) {
                KFImage(URL(string: content.image))
                    .resizable()
                    .aspectRatio(0.8, contentMode: .fill)
                    .onTapGesture {
                        onTap()
                    }
                if content.isRecentlyAdded {
                    Text("Recently Added")
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(Color.netflixWhite)
                        .background(Color.netflixRed)
                        .cornerRadius(2)
                        .lineLimit(1)
                        .font(.caption2)
                        .fontWeight(.bold)
                        .minimumScaleFactor(0.1)
                        .padding(.horizontal, 20)
                }
            }
            .cornerRadius(20)
        }
        .frame(height: height)
    }
}

#Preview {
    NetflixCell(content: .init(image: "https://m.media-amazon.com/images/M/MV5BNDgwY2YyNjctZTMxZC00ZTRlLThhN2QtMTAwYjUyODcyZDYxXkEyXkFqcGdeQXVyMTA0MTM5NjI2._V1_FMjpg_UX1000_.jpg",
                               title: "Game Of Thrones",
                               subtitle: "A Song of Ice and Fire",
                               genres: ["Histrory", "Epic", "Thriller"],
                               isNetflixFilm: true,
                              isRecentlyAdded: true,
                              ranking: 10),
                onTap: {})
}
