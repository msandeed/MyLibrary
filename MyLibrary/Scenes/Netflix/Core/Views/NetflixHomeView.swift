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
    
    @State var showAlert: Bool = false
    @State var alertTitle: String = ""
    
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
                    mainSection
                        .padding(.horizontal, 12)
                    topListSection
                    otherListSection
                    
                    Spacer()
                }
                .scrollIndicators(.hidden)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle), dismissButton: .default(Text("OK")))
            }
        }
        .foregroundStyle(Color.netflixWhite)
    }
    
    private var header: some View {
        VStack {
            HStack {
                Text("For You")
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 16) {
                    Image(systemName: "tv.badge.wifi")
                        .onTapGesture {
                            alertTitle = "Screen Mirroring to be added"
                            showAlert = true
                        }
                    Image(systemName: "magnifyingglass")
                        .onTapGesture {
                            alertTitle = "Search to be added"
                            showAlert = true
                        }
                }
            }
            .font(.headline)
            .padding(.horizontal)
            
            NetflixFilterBar(filterItems: FilterItem.mockedItems,
                             selectedItem: $selectedItem)
        }
    }
    
    private var mainSection: some View {
        let product: NetflixProduct.NetflixProductViewModel = viewModel.output.products.first ?? .init(image: "", title: "", subtitle: "")
        
        return NetflixMainCell(content: product,
                               onBackgroundTap: {
            coordinator.present(.netflixSingleProduct(product: product))
        },
                               onPlayTap: {
            alertTitle = "Play to be added"
            showAlert = true
        },
                               onMyListTap: {
            alertTitle = "Add to My List to be added"
            showAlert = true
        })
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
                        NetflixCell(content: product, onTap: {
                            coordinator.present(.netflixSingleProduct(product: product))
                        })
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
                        NetflixCell(content: product, onTap: {
                            coordinator.present(.netflixSingleProduct(product: product))
                        })
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
