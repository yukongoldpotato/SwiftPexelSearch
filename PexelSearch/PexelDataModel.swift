//
//  PexelDataModel.swift
//  PexelSearch
//
//  Created by Kazuki Minami on 2025/05/21.
//

import Foundation

struct PexelsSearchResponse: Codable {
    let totalResults: Int
    let page: Int
    let perPage: Int
    let photos: [Photo]
    let nextPage: String?

    enum CodingKeys: String, CodingKey {
        case totalResults = "total_results"
        case page
        case perPage = "per_page"
        case photos
        case nextPage = "next_page"
    }
}

struct Photo: Codable, Identifiable, Hashable { // Identifiable & Hashable for SwiftUI lists
    let id: Int
    let width: Int
    let height: Int
    let url: String // URL to Pexels page
    let photographer: String
    let photographerUrl: String
    let photographerId: Int
    let avgColor: String
    let src: PhotoSource
    let liked: Bool
    let alt: String

    enum CodingKeys: String, CodingKey {
        case id, width, height, url, photographer, liked, alt, src
        case photographerUrl = "photographer_url"
        case photographerId = "photographer_id"
        case avgColor = "avg_color"
    }

    // Conformance to Hashable (id is usually sufficient for uniqueness)
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Photo, rhs: Photo) -> Bool {
        lhs.id == rhs.id
    }
}

struct PhotoSource: Codable, Hashable {
    let original: String
    let large2x: String
    let large: String
    let medium: String
    let small: String
    let portrait: String
    let landscape: String
    let tiny: String
}
