//
//  MyLibraryApp.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 27/07/2022.
//

import SwiftUI
import FirebaseCore

@main
struct MyLibraryApp: App {
    
    init() {
        setupAndTestRemoteConfig()
        setupAnalyticsKit() // Analytics should be setup at app start or any appropriate point in the app's flow depending on the need.
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
    
    func setupAndTestRemoteConfig() {
        FirebaseApp.configure()
        
        let remoteConfigManager = RemoteConfigManager()
        remoteConfigManager.fetchConfig {
            let message = remoteConfigManager.getWelcomeMessage()
            print("📝 \(message)")
        }
    }
}
