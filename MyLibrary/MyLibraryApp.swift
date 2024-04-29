//
//  MyLibraryApp.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 27/07/2022.
//

import SwiftUI

@main
struct MyLibraryApp: App {
    var body: some Scene {
        WindowGroup {
            CoordinatorView(coordinator: ExampleCoordinator(), homePage: .alien)
//            CoordinatorView(coordinator: BooksFlowCoordinator(), homePage: .books)
//            BooksView(viewModel: BooksListViewModel())
//            CoordinatorView(coordinator: NetflixFlowCoordinator(), homePage: .netflixHome)
//            Demo()
        }
    }
}
