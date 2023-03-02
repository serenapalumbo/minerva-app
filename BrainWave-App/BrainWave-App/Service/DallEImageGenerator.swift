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

    func createVariations(imageName: String) throws {
        let parameters = [
            ["key": "image", "src": "/Users/marcodellisola/Desktop/ss.png", "type": "file"],
            ["key": "n", "value": "1", "type": "text"],
            ["key": "size", "value": "1024x1024", "type": "text"],
            ["key": "response_format", "value": "url", "type": "text"]
        ]

        let boundary = "Boundary-\(UUID().uuidString)"
        var bodyData = Data()

        for parameter in parameters {
            guard parameter["disabled"] == nil else { continue }

            let parameterName = parameter["key"]!

            bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
            bodyData.append("Content-Disposition: form-data; name=\"\(parameterName)\"\r\n\r\n".data(using: .utf8)!)

            if let parameterValue = parameter["value"] {
                bodyData.append("\(parameterValue)\r\n".data(using: .utf8)!)
            } else if let parameterSrc = parameter["src"],
                      let fileData = try? Data(contentsOf: URL(fileURLWithPath: parameterSrc)),
                      let fileContent = String(data: fileData, encoding: .utf8) {
                let contentType = "content-type header"
                let filename = URL(fileURLWithPath: parameterSrc).lastPathComponent

                bodyData.append("; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
                bodyData.append("Content-Type: \(contentType)\r\n\r\n".data(using: .utf8)!)
                bodyData.append(fileContent.data(using: .utf8)!)
                bodyData.append("\r\n".data(using: .utf8)!)
            }
        }

        bodyData.append("--\(boundary)--\r\n".data(using: .utf8)!)

        var request = URLRequest(url: URL(string: "https://api.openai.com/v1/images/variations")!)
        request.httpMethod = "POST"
        request.addValue("Bearer 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", forHTTPHeaderField: "Authorization")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = bodyData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }

            print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
}

enum ImageError: Error {
    case inValidPrompt, badURL, invalidImage, cantFindImage
}
