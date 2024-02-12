//
//  ContentView.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 28/10/2021.
//

import SwiftUI

struct BooksView<CoordinatorType: Navigator>: BaseViewProtocol {
    @StateObject var viewModel: BooksListViewModel = .init()
    var coordinator: CoordinatorType
    
    init(coordinator: CoordinatorType) {
        self.coordinator = coordinator
    }
    
    var body: some View {
        VStack {
            List(viewModel.output.books) { book in
                VStack(alignment: .leading) {
                    Text("\(book.title)")
                        .font(.headline)
                        .bold()
                    Text("\(book.subtitle)")
                        .font(.subheadline)
                }
                .onTapGesture {
                    coordinator.push(.singleBook(book: book))
                }
            }
        }
        .refreshable {
            viewModel.input.fetchTrigger.send(())
        }
    }
}

struct BooksView_Previews: PreviewProvider {
    static var previews: some View {
        UsecasesContainer.booksUsecase.register { MockedBooksUseCase() }
        
        return BooksView(coordinator: BooksFlowCoordinator())
    }
}
