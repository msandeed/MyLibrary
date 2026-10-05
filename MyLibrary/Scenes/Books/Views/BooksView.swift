//
//  ContentView.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 28/10/2021.
//

import SwiftUI
@preconcurrency import Factory

struct BooksView<CoordinatorType: Coordinator>: @MainActor BaseViewProtocol {
    @StateObject var viewModel: BooksListViewModel = .init()
    var coordinator: CoordinatorType
    
    init(coordinator: CoordinatorType) {
        self.coordinator = coordinator
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Text("My Books")
                .font(.largeTitle)
                .bold()
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
            .listStyle(.plain)
            .overlay {
                // Only when there's nothing to show yet; with existing rows, pull-to-refresh has its own indicator.
                if viewModel.output.books.isEmpty {
                    switch viewModel.output.viewState {
                    case .loading:
                        ProgressView()
                    case .error:
                        ContentUnavailableView {
                            Label("Couldn't Load Books", systemImage: "wifi.exclamationmark")
                        } description: {
                            Text("Check your connection and try again.")
                        } actions: {
                            Button("Retry") {
                                viewModel.input.fetchTrigger.send(())
                            }
                        }
                    default:
                        EmptyView()
                    }
                }
            }
        }
        .padding(.top)
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
