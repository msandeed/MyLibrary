//
//  NetflixProductView.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 18/04/2024.
//

import SwiftUI

struct NetflixProductView: View {
    var product: NetflixProduct.NetflixProductViewModel
    
    var body: some View {
        Text(product.title)
            .font(.largeTitle)
            .bold()
            .multilineTextAlignment(.center)
    }
}

#Preview {
    NetflixProductView(product: .init(image: "", title: "", subtitle: ""))
}

