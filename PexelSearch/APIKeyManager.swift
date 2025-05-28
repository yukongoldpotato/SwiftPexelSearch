//
//  APIKeyManager.swift
//  PexelSearch
//
//  Created by Kazuki Minami on 2025/05/21.
//

import Foundation

enum APIKeyManager {
    static var pexelsAPIKey: String? {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "PexelsAPIKey") as? String else { return nil }
        // Confirm that its not the placeholder
        if apiKey == "$(PEXELS_API_KEY)" || apiKey.isEmpty { return nil }
        return apiKey
    }
}

// let apiKey = APIKeyManager.pexelsAPIKey
