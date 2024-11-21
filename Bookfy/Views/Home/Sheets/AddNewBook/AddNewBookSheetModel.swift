//
//  AddNewBookSheetModel.swift
//  Bookfy
//
//  Created by Andre Rocha on 19/11/2024.
//

import Foundation

struct SearchBooksResponseStruct: Decodable {
    let numFound: Int
    let docs: [BookApiStruct]
}

class AddNewBookSheetModel: ObservableObject {
    let networkManager = NetworkManager()
    
    @Published var searchText: String = ""
    @Published var books: [BookApiStruct] = []
    
    func handleSearchBooks(query: String) {
        networkManager.request(endpoint: "?title=\(query)", method: "GET") { (result: Result<SearchBooksResponseStruct, NetworkError>) in
            switch result {
            case .success(let response):
                self.books = response.docs
            case .failure(_):
                break
            }
        }
    }
}
