//
//  ContentView.swift
//  PexelSearch
//
//  Created by Kazuki Minami on 2025/05/21.
//

import SwiftUI

struct ContentView: View {
    @State private var searcher = PhotoSearcher()

    var body: some View {
        NavigationStack {
            List(searcher.photos) { photo in
                AsyncImage(url: URL(string: photo.src.small))
            }
            .navigationTitle("Images")
            .searchable(text: $searcher.searchText, prompt: "Search for an image")
            .onSubmit(of: .search) {
                searcher.performSearch()
            }
        }
    }
}

#Preview {
    ContentView()
}
