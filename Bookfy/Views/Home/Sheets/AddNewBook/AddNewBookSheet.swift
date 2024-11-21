//
//  AddNewBookSheet.swift
//  Bookfy
//
//  Created by Andre Rocha on 19/11/2024.
//

import SwiftUI
import SwiftData

struct AddNewBookSheet: View {
    @StateObject private var viewModel = AddNewBookSheetModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Search...", text: $viewModel.searchText)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                    
                    Button(action: {
                        viewModel.handleSearchBooks(query: viewModel.searchText)
                    }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                }
                
                List {
                    ForEach(viewModel.books, id: \.title) { book in
                        NavigationLink {
                            AddBookFormView(bookApi: book)
                        } label: {
                            Text("\(book.title)")
                        }
                    }
                }
                .overlay {
                    if viewModel.books.isEmpty {
                        ContentUnavailableView {
                            Label("Search for books", systemImage: "tray.fill")
                        } description: {
                            Text("Type the book's name and get results")
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .padding()
        }
    }
}

#Preview {
    AddNewBookSheet()
}
