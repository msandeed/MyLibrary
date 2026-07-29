//
//  WithContinuationExample.swift
//  DraftSwiftUI
//
//  Created by Mostafa Sandeed on 29/01/2024.
//

import SwiftUI

struct WithContinuationExampleDataProvider {
    // Wraps the old completion-handler-based dataTask API in async/await.
    // withCheckedThrowingContinuation suspends the calling task until resume(returning:/throwing:)
    
    // Called exactly once — the "checked" variant fatally traps if resume is called a second
    // time, and logs a runtime warning if the continuation is deallocated without ever resuming
    // (a hang),
    // Why this matters: the alternative, withUnsafeThrowingContinuation, does none of this bookkeeping — get the resume-once contract wrong there and you get a silent hang or undefined behavior with zero diagnostics.
    func downloadImage(using urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data, let image = UIImage(data: data) {
                    continuation.resume(returning: image)
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: URLError(.unknown))
                }
            }
            .resume()
        }
    }
}

@MainActor
class WithContinuationExampleViewModel: ObservableObject {
    @Published var image: UIImage?
    let dataProvider = WithContinuationExampleDataProvider()
    
    func getImage() async {
        self.image = try? await dataProvider.downloadImage(using: "https://picsum.photos/300")
    }
}

struct WithContinuationExample: View {
    @ObservedObject var viewModel = WithContinuationExampleViewModel()
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
            }
        }
        .navigationTitle("Task Group")
        .task {
            await viewModel.getImage()
        }
    }
}

struct WithContinuationExample_Previews: PreviewProvider {
    static var previews: some View {
        WithContinuationExample()
    }
}
