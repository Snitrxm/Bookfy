//
//  AddBookFormViewModel.swift
//  Bookfy
//
//  Created by Andre Rocha on 19/11/2024.
//

import Foundation
import SwiftData

class AddBookFormViewModel: ObservableObject {
    var modelContext: ModelContext?
    var bookApi: BookApiStruct
    
    @Published var summaryTextField: String = ""
    @Published var ratingPicker: Int = 1
    @Published var readAtDatePicker: Date = .now
    
    init(bookApi: BookApiStruct) {
        self.bookApi = bookApi
    }
    
    func handleCreateBook() -> Void {
        let book = Book(name: bookApi.title, summary: summaryTextField, rating: ratingPicker, readAt: readAtDatePicker)
        modelContext?.insert(book)
        try? modelContext?.save()
    }
}
