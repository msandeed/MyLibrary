//
//  TaskGroupExample.swift
//  DraftSwiftUI
//
//  Created by Mostafa Sandeed on 28/01/2024.
//

import SwiftUI

class TaskGroupExampleDataProvider {
    // Not as scalable as TaskGroup
    func downloadImagesWithAsyncLet() async throws -> [UIImage] {
        do {
            async let fetchImage1 = downloadImage(using: "https://picsum.photos/300")
            async let fetchImage2 = downloadImage(using: "https://picsum.photos/300")
            async let fetchImage3 = downloadImage(using: "https://picsum.photos/300")
            async let fetchImage4 = downloadImage(using: "https://picsum.photos/300")
            
            let (image1, image2, image3, image4) = try await (fetchImage1, fetchImage2, fetchImage3, fetchImage4)
            return [image1, image2, image3, image4]
        } catch {
            throw error
        }
    }
    
    func downloadImagesWithTaskGroup() async throws -> [UIImage] {
        var images: [UIImage] = []
        return try await withThrowingTaskGroup(of: UIImage?.self) { group in
            for _ in 0 ... 7 {
                group.addTask {
                    try? await self.downloadImage(using: "https://picsum.photos/300")
                }
            }
            
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
