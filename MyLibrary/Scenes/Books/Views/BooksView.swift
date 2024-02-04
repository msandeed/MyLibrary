//
//  ContentView.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 28/10/2021.
//

import SwiftUI

struct BooksView: BaseViewProtocol {
    @ObservedObject var navigator = Navigator()
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
                    }.sheet(isPresented: $navigator.isActive) {
                        Text("")
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
        UsecasesContainer.booksUsecase.register { MockedBooksUseCase() }
        
        return BooksView(viewModel: BooksListViewModel())
    }
}
