//
//  ImageGenerationResponse.swift
//  BrainWave-App
//
//  Created by Serena on 21/02/23.
//

import Foundation

struct ImageGenerationResponse: Codable {
    struct ImageResponse: Codable {
        let url: URL
    }
    
    let created: Int
    let data: [ImageResponse]
}
