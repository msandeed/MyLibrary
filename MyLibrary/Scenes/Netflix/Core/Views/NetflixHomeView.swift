//
//  NetflixHome.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 16/04/2024.
//

import SwiftUI

struct NetflixHomeView<CoordinatorType: Navigator>: BaseViewProtocol {
    @StateObject var viewModel: NetflixHomeViewModel = .init()
    var coordinator: CoordinatorType
    
    init(coordinator: CoordinatorType) {
        self.coordinator = coordinator
    }
    
    @State private var selectedItem: FilterItem? = nil
    
    var body: some View {
        ZStack {
            Color.netflixBlack.ignoresSafeArea()
            VStack(spacing: 20) {
                header
                ScrollView(.vertical) {
                    NetflixFilterBar(filterItems: FilterItem.mockedItems,
                                     selectedItem: $selectedItem)
                    mainSection
                        .padding(.horizontal, 12)
                    topListSection
                    otherListSection
                    
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
                .bold()
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
    
    private var mainSection: some View {
        let product: NetflixProduct.NetflixProductViewModel = viewModel.output.products.first ?? .init(image: "", title: "", subtitle: "")
        
        return NetflixMainCell(content: product,
                               onBackgroundTap: {},
                               onPlayTap: {},
                               onMyListTap: {})
    }
    
    private var topListSection: some View {
        VStack(spacing: 4) {
            Text("Top List")
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            ScrollView(.horizontal) {
                LazyHStack(spacing: 20) {
                    ForEach(viewModel.topList, id: \.self) { product in
                        NetflixCell(content: product, onTap: {})
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .padding(.horizontal, 8)
    }
    
    private var otherListSection: some View {
        VStack(spacing: 4) {
            Text("Recommendations")
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 24)
            ScrollView(.horizontal) {
                LazyHStack(spacing: 20) {
                    ForEach(viewModel.otherList, id: \.self) { product in
                        NetflixCell(content: product, onTap: {})
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .padding(.horizontal, 8)
    }
}

#Preview {
    NetflixHomeView(coordinator: NetflixFlowCoordinator())
}
