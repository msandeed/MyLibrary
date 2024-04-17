//
//  PreviewHandler.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 30/12/2022.
//

import Foundation

var previewBooks: [Book.BookDTO] = load("FakeBooks.json")
var previewProducts: [NetflixProduct.NetflixProductDTO] = load("FakeNetflixProducts.json")

// Function that loads JSON data into a T type and returns the decoded data
func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
