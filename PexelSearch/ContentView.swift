//
//  ContentView.swift
//  PexelSearch
//
//  Created by Kazuki Minami on 2025/05/21.
//

import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    let allItems = ["Apple", "Banana", "Carrot", "Donkey", "Emu"]
    var filteredItems: [String] {
        if searchText.isEmpty {
            return allItems
        } else {
            return allItems.filter {
                $0.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationStack {
            List(filteredItems, id: \.self) { item in
                Text(item)
            }
            .navigationTitle("Images")
            .searchable(text: $searchText, prompt: "Search for an image")
        }
    }
}

#Preview {
    ContentView()
}
