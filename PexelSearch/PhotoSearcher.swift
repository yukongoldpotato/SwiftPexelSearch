//
//  PhotoSearcher.swift
//  PexelSearch
//
//  Created by Kazuki Minami on 2025/05/21.
//

import Foundation

@Observable
class PhotoSearcher {
    var searchText: String = ""
    var photos: [Photo] = []
    private var searchTask: Task<Void, Never>?
    private var curationTask: Task<Void, Never>?

    private let apiService = PexelsAPIService()

    func performSearch() {
        searchTask?.cancel()
        searchTask = Task { [weak self] in
            guard let self, !Task.isCancelled else { return }
            do {
                let response = try await apiService.searchPhotos(query: self.searchText)
                guard !Task.isCancelled else { return }
                self.photos = response.photos
            } catch {
                print("Error searching photos for query '\(self.searchText)': \(error)")
                self.photos = []
            }
        }
    }

    func performCuration() {
        curationTask?.cancel()
        curationTask = Task { [weak self] in
            guard let self, !Task.isCancelled else { return }
            do {
                let response = try await apiService.curatedPhotos()
                guard !Task.isCancelled else { return }
                self.photos = response.photos
            } catch {
                print("Error fetching curated photos: \(error)")
            }
        }
    }

    deinit {
        searchTask?.cancel()
        curationTask?.cancel()
    }
}
