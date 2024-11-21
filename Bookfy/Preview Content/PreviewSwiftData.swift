//
//  PreviewSwiftDta.swift
//  Bookfy
//
//  Created by Andre Rocha on 19/11/2024.
//

import SwiftData

@MainActor
struct Preview {
    let container: ModelContainer
    init() {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        do {
            container = try ModelContainer(for: Book.self, configurations: config)
            
            let book = Book(name: "Rich dad Poor dad", summary: "Legal", rating: 1, readAt: .now)
            container.mainContext.insert(book)
            try container.mainContext.save()
        } catch {
            fatalError("Could not create preview container")
        }
    }
}
