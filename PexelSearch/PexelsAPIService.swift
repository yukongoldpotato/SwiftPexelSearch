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
            print("❌ Pexels API Key is missing or empty from APIKeyManager.")
            throw PexelsAPIError.apiKeyMissing
        }

        print("🔑 Attempting to use Pexels API Key: '\(apiKey)'")

        if apiKey == "PEXELS_API_KEY" {
            print("❌ Pexels API Key is still the placeholder value!")
            throw PexelsAPIError.apiKeyMissing
        }

        print("🔑 Attempting to use Pexels API Key (length: \(apiKey.count)): '\(apiKey)'")
        if let keyData = apiKey.data(using: .utf8) {
            print("🔑 API Key UTF-8 bytes: \(keyData.map { String(format: "%02x", $0) }.joined())")
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
        print("🔍 Request Details Before Sending:")
        print("🔍 URL: \(request.url?.absoluteString ?? "N/A")")
        print("🔍 HTTP Method: \(request.httpMethod ?? "N/A")")
        print("🔍 All HTTP Header Fields: \(request.allHTTPHeaderFields ?? [:])")
        if let authHeader = request.value(forHTTPHeaderField: "Authorization") {
            print("🔍   Authorization Header Value Being Sent: '\(authHeader)'")
            if authHeader != apiKey {
                print("⚠️ MISMATCH: Authorization header value is different from the apiKey variable!")
            }
        } else {
            print("⚠️ Authorization header is NOT SET on the request object!")
        }
        request.httpMethod = "GET"

        print("🚀 Requesting URL: \(url.absoluteString)")

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw PexelsAPIError.invalidResponse
            }

            print("✅ Response Status Code: \(httpResponse.statusCode)")

            guard (200...299).contains(httpResponse.statusCode) else {
                if let errorBody = String(data: data, encoding: .utf8) {
                    print("❌ HTTP Error Body: \(errorBody)")
                }
                throw PexelsAPIError.httpError(statusCode: httpResponse.statusCode)
            }

            let decoder = JSONDecoder()
            do {
                let searchResponse = try decoder.decode(PexelsSearchResponse.self, from: data)
                return searchResponse
            } catch {
                print("❌ Decoding Error: \(error)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📄 Received JSON: \(jsonString)")
                }
                throw PexelsAPIError.decodingError(error)
            }
        }
    }
}
