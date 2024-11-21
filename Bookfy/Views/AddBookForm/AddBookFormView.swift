//
//  AddBookViewq.swift
//  Bookfy
//
//  Created by Andre Rocha on 19/11/2024.
//

import SwiftUI
import SwiftData

struct AddBookFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @StateObject private var viewModel: AddBookFormViewModel
    var bookApi: BookApiStruct
    
    init(bookApi: BookApiStruct) {
        self.bookApi = bookApi
        _viewModel = StateObject(wrappedValue: .init(bookApi: bookApi))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    TextField("Book summary", text: $viewModel.summaryTextField)
                    Picker("Rating", selection: $viewModel.ratingPicker) {
                        Text("1").tag(1)
                        Text("2").tag(2)
                        Text("3").tag(3)
                        Text("4").tag(4)
                        Text("5").tag(5)
                    }
                    
                    DatePicker("Read At", selection: $viewModel.readAtDatePicker, displayedComponents: [.date])
                }
            }
            .toolbar {
                ToolbarItem {
                    Button(action:{
                        viewModel.handleCreateBook()
                    }) {
                        Text("Create")
                    }
                }
            }
            .onAppear {
                viewModel.modelContext = modelContext
            }
            .navigationTitle(bookApi.title)
        }
    }
}

#Preview {
    @Previewable @State var bookApi: BookApiStruct = .init(title: "Rich dad Poor Dad")
    
    let preview = Preview()
    
    return AddBookFormView(bookApi: bookApi)
        .modelContainer(preview.container)
}
