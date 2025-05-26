//
//  ExploreView.swift
//  PexelSearch
//
//  Created by Kazuki Minami on 2025/05/21.
//

import SwiftUI
import WaterfallGrid
import SwiftData

struct ExploreView: View {
    @State private var searcher = PhotoSearcher()
    @Environment(\.modelContext) private var modelContext
    @Query private var savedPhotos: [SavedPhoto]
    @State private var selectedPhoto: Photo?

    var body: some View {
        NavigationStack {
            ScrollView {
                WaterfallGrid(searcher.photos, id: \.id) { photo in
                    AsyncImage(url: URL(string: photo.src.large)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(CGFloat(photo.width) / CGFloat(photo.height), contentMode: .fit)
                                .cornerRadius(15)
                                .overlay(alignment: .bottomTrailing) {
                                    let isSaved = savedPhotos.contains { $0.id == photo.id }
                                    Button {
                                        if isSaved {
                                            if let existing = savedPhotos.first(where: { $0.id == photo.id }) {
                                                modelContext.delete(existing)
                                            }
                                        } else {
                                            Task { await downloadAndSave(photo: photo) }
                                        }
                                    } label: {
                                        Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
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
                    .onTapGesture {
                        selectedPhoto = photo
                    }
                }
                .gridStyle(columns: 2, spacing: 6)
                .padding(6)
            }
            .navigationTitle("Images")
            .searchable(text: $searcher.searchText, prompt: "Search for an image")
            .onSubmit(of: .search) {
                searcher.performSearch()
            }
            .sheet(item: $selectedPhoto) { selected in
                let isSaved = savedPhotos.contains { $0.id == selected.id }
                PhotoDetailView(
                    photo: selected,
                    isSaved: isSaved,
                    toggleSave: {
                        if isSaved {
                            if let existing = savedPhotos.first(where: { $0.id == selected.id }) {
                                modelContext.delete(existing)
                            }
                        } else {
                            Task { await downloadAndSave(photo: selected) }
                        }
                    }
                )
            }
            .task {
                // Load curated photos on first launch if no search query
                guard searcher.searchText.isEmpty else { return }
                searcher.performCuration()
            }
        }
    }

    func downloadAndSave(photo: Photo) async {
        do {
            guard let url = URL(string: photo.src.large) else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            let saved = SavedPhoto(
                id: photo.id,
                photographer: photo.photographer,
                originalURL: photo.url,
                imageData: data,
                alt: photo.alt
            )
            modelContext.insert(saved)
        } catch {
            print("Save error: \(error)")
        }
    }
}

#Preview {
    ExploreView()
}
