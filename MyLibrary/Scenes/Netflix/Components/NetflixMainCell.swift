//
//  NetflixMainCell.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 16/04/2024.
//

import SwiftUI

struct MainCellItem {
    let image: String   // Should be a url
    let title: String
    let subtitle: String
    var genres: [String] = []
    var isNetflixFilm: Bool = false
    var isRecentlyAdded: Bool = false
    var isTopTen: Bool = false
}

struct NetflixMainCell: View {
    var content: MainCellItem
    var onBackgroundTap: () -> Void
    var onPlayTap: () -> Void
    var onMyListTap: () -> Void
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Image(content.image)
                .resizable()
                .aspectRatio(0.8, contentMode: .fill)
                .onTapGesture {
                    onBackgroundTap()
                }
            VStack(spacing: 20) {
                if content.isNetflixFilm {
                    netflixFilmSection
                }
                
                productDetailsSection
                controlSection
                
            }
            .padding(24)
            .foregroundStyle(Color.netflixWhite)
            .background(
                LinearGradient(colors: [Color.netflixBlack.opacity(0),
                                        Color.netflixBlack.opacity(0.4)],
                               startPoint: .top,
                               endPoint: .bottom)
            )
        }
        .cornerRadius(20)
        .padding()
        .aspectRatio(0.8, contentMode: .fit)
    }
    
    var netflixFilmSection: some View {
        HStack {
            Text("N")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(Color.netflixRed)
            Text("FILM")
                .kerning(3.0)
        }
    }
    
    var productDetailsSection: some View {
        VStack(spacing: 0) {
            Text(content.title)
                .font(.largeTitle)
                .bold()
            Text(content.subtitle)
                .font(.headline)
            HStack {
                ForEach(content.genres, id: \.self) { genre in
                    Text(genre)
                        .font(.footnote)
                    if genre != content.genres.last {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(width: 5, height: 5)
                    }
                }
            }
            .padding(.top, 8)
        }
    }
    
    var controlSection: some View {
        HStack(spacing: 8) {
            HStack {
                Image(systemName: "play.fill")
                Text("Play")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .foregroundStyle(Color.netflixDarkGray)
            .background(Color.netflixWhite)
            .cornerRadius(4)
            .onTapGesture {
                onPlayTap()
            }
            
            HStack {
                Image(systemName: "plus")
                Text("My List")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .foregroundStyle(Color.netflixWhite)
            .background(Color.netflixDarkGray)
            .cornerRadius(4)
            .onTapGesture {
                onMyListTap()
            }
            
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    NetflixMainCell(content: .init(image: "testbg",
                                   title: "Game Of Thrones",
                                   subtitle: "A Song of Ice and Fire",
                                  genres: ["Histrory", "Epic", "Thriller"],
                                  isNetflixFilm: true),
                    onBackgroundTap: {},
                    onPlayTap: {},
                    onMyListTap: {})
}
