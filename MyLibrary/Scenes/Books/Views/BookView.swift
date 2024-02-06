//
//  BookView.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 28/10/2021.
//

import SwiftUI

struct BookView<CoordinatorType: Coordinator>: BaseViewProtocol {
    var book: Book.BookItemViewModel
    @ObservedObject var viewModel: DummyViewModel
    var coordinator: CoordinatorType
    
    init(book: Book.BookItemViewModel, viewModel: DummyViewModel, coordinator: CoordinatorType) {
        self.book = book
        self.viewModel = viewModel
        self.coordinator = coordinator
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text(book.title)
                .font(.headline)
                .bold()
            Text(book.subtitle)
                .font(.subheadline)
            Spacer()
            Button("Return") {
                coordinator.pop()
            }
        }
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        BookView(book: Book.BookItemViewModel(id: 0, title: "Fake Book", subtitle: "Fake Author"),
                 viewModel: .init(),
                 coordinator: BooksFlowCoordinator())
    }
}
