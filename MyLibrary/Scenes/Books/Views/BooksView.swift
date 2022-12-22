//
//  ContentView.swift
//  Books-SwiftUIwMVVM
//
//  Created by Mostafa Sandeed on 28/10/2021.
//

import SwiftUI

struct BooksView: BaseView {
    
    @ObservedObject var viewModel: BooksListViewModel
    
    init(viewModel: BooksListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            List(viewModel.output.books) { book in
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
            .onAppear {
                viewModel.input.fetchTrigger.send(())
            }
        }
    }
}

struct BooksView_Previews: PreviewProvider {
    static var previews: some View {
        BooksView(viewModel: BooksListViewModel())
    }
}
