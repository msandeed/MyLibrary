//
//  TaskGroupExample.swift
//  DraftSwiftUI
//
//  Created by Mostafa Sandeed on 28/01/2024.
//

import SwiftUI

struct TaskGroupExampleDataProvider {
    // async let starts each download concurrently, but the number of child tasks must be known
    // and written out at compile time — not as scalable as TaskGroup for a dynamic count.
    func downloadImagesWithAsyncLet() async throws -> [UIImage] {
        do {
            async let fetchImage1 = downloadImage(using: "https://picsum.photos/300")
            async let fetchImage2 = downloadImage(using: "https://picsum.photos/300")
            async let fetchImage3 = downloadImage(using: "https://picsum.photos/300")
            async let fetchImage4 = downloadImage(using: "https://picsum.photos/300")

            // Awaiting the tuple suspends until all four finish; if any throws, the others are
            // implicitly cancelled and this rethrows.
            let (image1, image2, image3, image4) = try await (fetchImage1, fetchImage2, fetchImage3, fetchImage4)
            return [image1, image2, image3, image4]
        } catch {
            throw error
        }
    }

    // TaskGroup scales to a dynamic number of children (here, a loop) and lets each one fail
    // independently — try? below drops failed downloads instead of cancelling the whole group.
    func downloadImagesWithTaskGroup() async throws -> [UIImage] {
        var images: [UIImage] = []
        return try await withThrowingTaskGroup(of: UIImage?.self) { group in
            for _ in 0 ... 7 {
                group.addTask {
                    try? await self.downloadImage(using: "https://picsum.photos/300")
                }
            }

            // Iterating the group awaits each child task as it completes, not in the order added.
            for try await image in group {
                if let image = image {
                    images.append(image)
                }
            }

            return images
        }
    }
    
    func downloadImage(using urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.badServerResponse)
            }
        } catch {
            throw URLError(.badServerResponse)
        }
    }
}

@MainActor
class TaskGroupExampleViewModel: ObservableObject {
    @Published var images: [UIImage] = []
    let dataProvider = TaskGroupExampleDataProvider()
    
    func getImages() async {
        if let images = try? await dataProvider.downloadImagesWithTaskGroup() {
            self.images.append(contentsOf: images)
        }
    }
}

struct TaskGroupExample: View {
    @ObservedObject var viewModel = TaskGroupExampleViewModel()
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
            }
        }
        .navigationTitle("Task Group")
        .task {
            await viewModel.getImages()
        }
    }
}

struct TaskGroupExample_Previews: PreviewProvider {
    static var previews: some View {
        TaskGroupExample()
    }
}
