//
//  ContentView.swift
//  Books-SwiftUIwMVVM
//
//  Created by Mostafa Sandeed on 28/10/2021.
//

import SwiftUI

struct BooksView: View {
    
    @ObservedObject var viewModel: BooksListViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.books) { book in
                NavigationLink(destination: BookView(book: book)) {
                    VStack(alignment: .leading) {
                        Text("\(book.title)")
                            .font(.headline)
                            .bold()
                        Text("\(book.subtitle)")
                            .font(.subheadline)
                    }
                }
            }
        }
    }
}

struct BooksView_Previews: PreviewProvider {
    static var previews: some View {
        BooksView(viewModel: BooksListViewModel())
    }
}
