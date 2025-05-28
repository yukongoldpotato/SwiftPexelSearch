//
//  PexelsAPIService.swift
//  PexelSearch
//
//  Created by Kazuki Minami on 2025/05/21.
//

import Foundation

class PexelsAPIService {
    private let baseURL = "https://api.pexels.com/v1/"
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func searchPhotos(query: String, perPage: Int = 20, page: Int = 1) async throws -> PexelsSearchResponse {
        guard let apiKey = APIKeyManager.pexelsAPIKey, !apiKey.isEmpty else {
            throw PexelsAPIError.apiKeyMissing
        }

        if apiKey == "PEXELS_API_KEY" {
            throw PexelsAPIError.apiKeyMissing
        }

        var components = URLComponents(string: baseURL + "search")
        components?.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "per_page", value: String(perPage)),
            URLQueryItem(name: "page", value: String(page))
        ]

        guard let url = components?.url else {
            throw PexelsAPIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw PexelsAPIError.invalidResponse
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                if let errorBody = String(data: data, encoding: .utf8) {
                }
                throw PexelsAPIError.httpError(statusCode: httpResponse.statusCode)
            }

            let decoder = JSONDecoder()
            do {
                let searchResponse = try decoder.decode(PexelsSearchResponse.self, from: data)
                return searchResponse
            } catch {
                if let jsonString = String(data: data, encoding: .utf8) {
                }
                throw PexelsAPIError.decodingError(error)
            }
        }
    }

    func curatedPhotos(perPage: Int = 20, page: Int = 1) async throws -> PexelsSearchResponse {
        let endpoint = "curated"
        var components = URLComponents(string: baseURL + endpoint)
        components?.queryItems = [
            URLQueryItem(name: "per_page", value: String(perPage)),
            URLQueryItem(name: "page", value: String(page))
        ]

        guard let url = components?.url else {
            throw PexelsAPIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.setValue(APIKeyManager.pexelsAPIKey, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"

        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw PexelsAPIError.httpError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? -1)
        }

        let decoder = JSONDecoder()
        return try decoder.decode(PexelsSearchResponse.self, from: data)
    }
}
