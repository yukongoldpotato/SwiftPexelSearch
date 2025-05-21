//
//  ExploreView.swift
//  PexelSearch
//
//  Created by Kazuki Minami on 2025/05/21.
//

import SwiftUI
import WaterfallGrid

struct ExploreView: View {
    @State private var searcher = PhotoSearcher()

    var body: some View {
        NavigationStack {
            ScrollView {
                WaterfallGrid(searcher.photos, id: \.id) { photo in
                    AsyncImage(url: URL(string: photo.src.medium)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(CGFloat(photo.width) / CGFloat(photo.height), contentMode: .fit)
                                .cornerRadius(15)
                                .overlay(alignment: .bottomTrailing) {
                                    Button {
                                        // TODO: implement save action here
                                    } label: {
                                        Image(systemName: "bookmark")
                                            .padding(8)
                                            .background(.ultraThinMaterial)
                                            .clipShape(Circle())
                                    }
                                    .padding(4)
                                }
                        default:
                            EmptyView()
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .gridStyle(columns: 2, spacing: 6)
                .padding(6)
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
    ExploreView()
}
