//
//  BookView.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 28/10/2021.
//

import SwiftUI

struct BookView<CoordinatorType: Navigator>: BaseViewProtocol {
    var book: Book.BookItemViewModel
    @StateObject var viewModel: DummyViewModel = .init()    // Currently a viewModel is not needed
    var coordinator: CoordinatorType
    
    init(book: Book.BookItemViewModel, coordinator: CoordinatorType) {
        self.book = book
        self.coordinator = coordinator
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text(book.title)
                .multilineTextAlignment(.center)
                .font(.title)
                .bold()
            Text(book.subtitle)
                .multilineTextAlignment(.center)
                .font(.header)
            Button("Return") {
                coordinator.pop()
            }
        }
        .padding()
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        BookView(book: Book.BookItemViewModel(id: 0,
                                              title: "Fake Book",
                                              subtitle: "Fake Author"),
                 coordinator: BooksFlowCoordinator())
    }
}
