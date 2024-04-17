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
                    
                    Section(header:
                        Text("Top List")
                            .font(.headline)
                            .textCase(.none)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    ) {
                        topListSection
                    }

                    Section(header:
                        Text("Recommendations")
                            .font(.headline)
                            .textCase(.none)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    ) {
                        otherListSection
                    }
                    
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
    
    private var mainSection: some View {
        let product: NetflixProduct.NetflixProductViewModel = viewModel.output.products.first ?? .init(image: "", title: "", subtitle: "")
        
        return NetflixMainCell(content: product,
                            onBackgroundTap: {},
                            onPlayTap: {},
                            onMyListTap: {})
    }
    
    private var topListSection: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 20) {
                ForEach(viewModel.topList, id: \.self) { product in
                    NetflixCell(content: product, onTap: {})
                }
            }
        }
        .scrollIndicators(.hidden)
    }
    
    private var otherListSection: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 20) {
                ForEach(viewModel.otherList, id: \.self) { product in
                    NetflixCell(content: product, onTap: {})
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    NetflixHomeView(coordinator: NetflixFlowCoordinator())
}
