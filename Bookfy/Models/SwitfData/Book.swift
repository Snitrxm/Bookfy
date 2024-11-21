//
//  Book.swift
//  Bookfy
//
//  Created by Andre Rocha on 19/11/2024.
//

import SwiftData
import Foundation

@Model
class Book {
    @Attribute(.unique) var name: String
    var summary: String
    var rating: Int
    var readAt: Date
    
    init(name: String, summary: String, rating: Int, readAt: Date) {
        self.name = name
        self.summary = summary
        self.rating = rating
        self.readAt = readAt
    }
}
