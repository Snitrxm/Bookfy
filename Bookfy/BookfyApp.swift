//
//  BookfyApp.swift
//  Bookfy
//
//  Created by Andre Rocha on 19/11/2024.
//

import SwiftUI
import SwiftData

@main
struct BookfyApp: App {
    var body: some Scene {
        WindowGroup {
            Home()
                .modelContainer(for: [Book.self])
        }
    }
}
