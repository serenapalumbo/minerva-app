//
//  GenerationViewModel.swift
//  BrainWave-App
//
//  Created by Marco Dell'Isola on 27/02/23.
//

import AsyncHTTPClient
import Foundation
import OpenAIKit
import UIKit

class GenerationViewModel: ObservableObject {
    @Published var prompt = ""
    @Published var imagePrompt: Data?
    @Published var generatedImages: [String] = []
    @Published var isLoading = false
    @Published var isDownloaded = false
    @Published var screenWidth = UIScreen.main.bounds.width
    @Published var screenHeight = UIScreen.main.bounds.height
    
    var openAIClient: OpenAIKit.Client?
    
    init() {
        let httpClient = HTTPClient(eventLoopGroupProvider: .createNew)
        let configuration = Configuration(apiKey: "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", organization: "org-zZXwenkqkE989XS1fTRV732A") // APIKEY and OrganizationID

        openAIClient = OpenAIKit.Client(httpClient: httpClient, configuration: configuration)
    }
}
