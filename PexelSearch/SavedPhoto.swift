//
//  SavedPhoto.swift
//  PexelSearch
//
//  Created by Kazuki Minami on 2025/05/21.
//

import Foundation
import SwiftData

@Model
final class SavedPhoto {
    var id: Int
    var photographer: String
    var originalURL: String
    var alt: String

    @Attribute(.externalStorage) var imageData: Data?

    init(id: Int, photographer: String, originalURL: String, imageData: Data? = nil, alt: String) {
        self.id = id
        self.photographer = photographer
        self.originalURL = originalURL
        self.imageData = imageData
        self.alt = alt
    }
}
