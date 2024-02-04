//
//  BookView.swift
//  MyLibrary
//
//  Created by Mostafa Sandeed on 28/10/2021.
//

import SwiftUI

struct BookView: View {
    var book: Book.BookItemViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text(book.title)
                .font(.headline)
                .bold()
            Text(book.subtitle)
                .font(.subheadline)
        }
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        BookView(book: Book.BookItemViewModel(id: 0, title: "Fake Book", subtitle: "Fake Author"))
    }
}
