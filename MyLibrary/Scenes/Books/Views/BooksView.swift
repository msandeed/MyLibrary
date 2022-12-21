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
                    let extractedExpr: VStack<TupleView<(Text, Text)>> = VStack {
                        Text(book.title)
                            .font(.headline)
                            .bold()
                        Text(book.subtitle)
                            .font(.subheadline)
                    }
                    extractedExpr
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
