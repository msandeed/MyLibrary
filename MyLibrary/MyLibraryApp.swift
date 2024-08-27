//
//  MyLibraryApp.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 27/07/2022.
//

import SwiftUI

@main
struct MyLibraryApp: App {
    
    init() {
        setupAnalyticsKit()
    }
    
    var body: some Scene {
        WindowGroup {
            CoordinatorView(coordinator: ExampleCoordinator(), homePage: .alien)
//            CoordinatorView(coordinator: BooksFlowCoordinator(), homePage: .books)
//            BooksView(viewModel: BooksListViewModel())
//            CoordinatorView(coordinator: NetflixFlowCoordinator(), homePage: .netflixHome)
//            Demo()
//            ThreadingDemoView()
        }
    }
}

extension MyLibraryApp {
    // Here we do the initial setup for Analytics. Any new Provider should be added here.
    func setupAnalyticsKit() {
        print("📊 Setting up AnalyticsKit")
        AnalyticsKit.main.configure(providers: [
            SomeAnalyticsProvider()
        ])
        
        AnalyticsKit.main.identifyUser(id: nil)     // Somewhere in a real app, the user would login. At that point we will set the id to the user's unique id

        AnalyticsKit.allProviders = [
            SomeAnalyticsProvider.self
        ]
    }
}
