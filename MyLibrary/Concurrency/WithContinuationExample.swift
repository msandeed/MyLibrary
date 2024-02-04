//
//  WithContinuationExample.swift
//  DraftSwiftUI
//
//  Created by Mostafa Sandeed on 29/01/2024.
//

import SwiftUI

class WithContinuationExampleDataProvider {
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
