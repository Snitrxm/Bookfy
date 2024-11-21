//
//  BookDetails.swift
//  Bookfy
//
//  Created by Andre Rocha on 19/11/2024.
//

import SwiftUI

struct BookDetailsView: View {
    var book: Book

    @StateObject private var viewModel: BookDetailsViewModel
    
    init(book: Book) {
        self.book = book
        _viewModel = StateObject(wrappedValue: .init(book: book))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(header: Text("Summary")) {
                        TextEditor(text: $viewModel.book.summary)
                    }
                    
                    Picker("Rating", selection: $viewModel.book.rating) {
                        Text("1").tag(1)
                        Text("2").tag(2)
                        Text("3").tag(3)
                        Text("4").tag(4)
                        Text("5").tag(5)
                    }
                }
            }
            .navigationTitle(book.name)
        }
    }
}

#Preview {
    @Previewable @State var book = Book(name: "Rich dad Poor dad", summary: "Very nice", rating: 1, readAt: .now)
    
    return BookDetailsView(book: book)
}
