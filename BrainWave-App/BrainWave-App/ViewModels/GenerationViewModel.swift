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
    
    func cropImageToSquare(image: UIImage) -> Data {
        let size = min(image.size.width, image.size.height)
        let originX = (image.size.width - size) / 2
        let originY = (image.size.height - size) / 2
        let cropRect = CGRect(x: originX, y: originY, width: size, height: size)
        let croppedImage = (image.cgImage?.cropping(to: cropRect))!
        let resizedImage = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512)).image { _ in
            UIImage(cgImage: croppedImage).draw(in: CGRect(x: 0, y: 0, width: 512, height: 512))
        }
        var compressionQuality: CGFloat = 0.8 // Initial compression quality
        var imageData = resizedImage.jpegData(compressionQuality: compressionQuality)
        
        // Keep compressing until the image size is under 4 MB
        while imageData?.count ?? 0 > 40_000 {
            compressionQuality -= 0.1
            guard compressionQuality > 0 else { return UIImage(data: imageData!)!.pngData()! }
            imageData = resizedImage.jpegData(compressionQuality: compressionQuality)
        }
        
        return UIImage(data: imageData!)!.pngData()!
    }
}
