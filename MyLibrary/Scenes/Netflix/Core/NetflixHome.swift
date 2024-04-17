//
//  NetflixHome.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 16/04/2024.
//

import SwiftUI

struct NetflixHome: View {
    @State private var selectedItem: FilterItem? = nil
    
    var body: some View {
        ZStack {
            Color.netflixBlack.ignoresSafeArea()
            VStack {
                header
                ScrollView(.vertical) {
                    NetflixFilterBar(filterItems: FilterItem.mockedItems,
                                     selectedItem: $selectedItem)
                    NetflixMainCell(content: .init(image: "testbg",
                                                   title: "Game Of Thrones",
                                                   subtitle: "A Song of Ice and Fire",
                                                  genres: ["Histrory", "Epic", "Thriller"],
                                                  isNetflixFilm: true),
                                    onBackgroundTap: {},
                                    onPlayTap: {},
                                    onMyListTap: {})
                    Spacer()
                }
                .scrollIndicators(.hidden)
            }
        }
        .foregroundStyle(Color.netflixWhite)
    }
    
    private var header: some View {
        HStack {
            Text("For You")
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 16) {
                Image(systemName: "tv.badge.wifi")
                    .onTapGesture {
                        
                    }
                Image(systemName: "magnifyingglass")
                    .onTapGesture {
                        
                    }
            }
        }
        .font(.headline)
        .padding()
    }
}

#Preview {
    NetflixHome()
}
