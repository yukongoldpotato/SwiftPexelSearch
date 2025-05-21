//
//  APIKeyManager.swift
//  PexelSearch
//
//  Created by Kazuki Minami on 2025/05/21.
//

import Foundation

enum APIKeyManager {
    static var pexelsAPIKey: String? {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "PexelsAPIKey") as? String else {
            fatalError("PexelsAPIKey not found in Info.plist. Make sure it's set in your xcconfig file.")
        }
        // Confirm that its not the placeholder
        if apiKey == "$(PEXELS_API_KEY)" || apiKey.isEmpty {
             fatalError("PEXELS_API_KEY was not replaced during build. Check xcconfig setup.")
        }
        return apiKey
    }
}

// let apiKey = APIKeyManager.pexelsAPIKey
