//
//  ContentView.swift
//  PexelSearch
//
//  Created by Kazuki Minami on 2025/05/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ExploreView()
                .tabItem {
                    Label("Explore", systemImage: "magnifyingglass")
                }

            SavedView()
                .tabItem {
                    Label("Saved", systemImage: "bookmark")
                }
        }
    }
}

#Preview {
    ContentView()
}
