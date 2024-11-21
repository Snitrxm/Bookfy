//
//  BookDetailsViewModel.swift
//  Bookfy
//
//  Created by Andre Rocha on 19/11/2024.
//

import Foundation

class BookDetailsViewModel: ObservableObject {
    @Published var book: Book
    
    init(book: Book) {
        self.book = book
    }
}
