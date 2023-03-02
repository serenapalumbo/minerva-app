//
//  DallEImageGenerator.swift
//  testAPI
//
//  Created by Serena on 18/02/23.
//

import Foundation
import SwiftUI

class DallEImageGenerator {
    static let shared = DallEImageGenerator()
    let sessionID = UUID().uuidString
    let apiKey = "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" // TODO: logic of retrieving the api key

    private init() { }

    func generateImage(withPrompt prompt: String) async throws -> ImageGenerationResponse {
        guard let url = URL(string: "https://api.openai.com/v1/images/generations") else {
            throw ImageError.badURL
        }

        let parameters: [String: Any] = [
            "prompt": prompt,
            "n": 4,
            "size": "1024x1024",
            "user": sessionID
        ]
        let data: Data = try JSONSerialization.data(withJSONObject: parameters)

        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = data

        let (response, _) = try await URLSession.shared.data(for: request)
        let result = try JSONDecoder().decode(ImageGenerationResponse.self, from: response)

        return result
    }
}

enum ImageError: Error {
    case inValidPrompt, badURL
}
