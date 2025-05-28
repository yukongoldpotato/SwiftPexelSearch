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

    private let apiService = PexelsAPIService()

    func performSearch() {
        Task {
            do {
                let response = try await apiService.searchPhotos(query: searchText)
                self.photos = response.photos
            } catch {
                print("Error searching photos for query '\(searchText)': \(error)")
                self.photos = []
            }
        }
    }

    func performCuration() {
        Task {
            do {
                let response = try await apiService.curatedPhotos()
                self.photos = response.photos
            } catch {
                print("Error fetching curated photos: \(error)")
            }
        }
    }
}
