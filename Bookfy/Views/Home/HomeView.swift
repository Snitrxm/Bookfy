//
//  ContentView.swift
//  Bookfy
//
//  Created by Andre Rocha on 19/11/2024.
//

import SwiftUI
import SwiftData

struct Home: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = HomeViewModel()
    @Query var books: [Book] // Using @Query in MVVM is a dumb decision
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(books, id: \.name) { book in
                        NavigationLink {
                            BookDetailsView(book: book)
                        } label: {
                            Text(book.name)
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            modelContext.delete(books[index])
                        }
                    }
                }
                .toolbar {
                    ToolbarItem {
                        Button(action: {
                            viewModel.isOpenAddNewBookSheet.toggle()
                        }) {
                            Text("Add")
                        }
                    }
                }
                .overlay {
                    if books.isEmpty {
                        ContentUnavailableView {
                            Label("No Books", systemImage: "tray.fill")
                        } description: {
                            Text("Click here to add a new book")
                        } actions: {
                            Button(action: {
                                viewModel.isOpenAddNewBookSheet.toggle()
                            }) {
                                Text("Add book")
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $viewModel.isOpenAddNewBookSheet){
                AddNewBookSheet()
            }
            .navigationTitle("Book's")
        }
    }
}

#Preview {
    let preview = Preview()
    
    Home()
        .modelContainer(preview.container)
}
