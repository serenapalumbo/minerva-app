//
//  ImageGenerationResponse.swift
//  BrainWave-App
//
//  Created by Serena on 21/02/23.
//

import Foundation

struct ImageGenerationResponse: Codable {
    let created: Int
    let data: [ImageResponse]

    struct ImageResponse: Codable {
        let url: URL
    }
}
