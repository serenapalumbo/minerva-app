//
//  ImageGeneration.swift
//  BrainWave-App
//
//  Created by Serena on 05/03/23.
//

import Foundation
import OpenAIKit
import SwiftUI
import UIKit

@MainActor
final class ImageGeneration {
    func startGeneration(collectionViewModel: CollectionsViewModel, generationViewModel: GenerationViewModel) {
        generationViewModel.isLoading = false
        generationViewModel.isDownloaded = false
        guard !generationViewModel.isLoading else {
            print("sto uscendo")
            return
        }
        generationViewModel.isLoading = true
        
        // initialize as empty the array of generated images
        generationViewModel.generatedImages.removeAll()
    }
    
    func generateImages(collectionViewModel: CollectionsViewModel, generationViewModel: GenerationViewModel) async {        
        do {
            let response: OpenAIKit.ImageResponse?
            
            if let image = generationViewModel.imagePrompt {
                response = try await generationViewModel.openAIClient?.images.createVariation(image: image, n: 4)
            } else {
                response = try await generationViewModel.openAIClient?.images.create(prompt: generationViewModel.prompt, n: 4)
            }
                                            
            for url in response!.data.map(\.url) {
                // append each url retrieved from the api to the array of the url of generated images
                generationViewModel.generatedImages.append(String(describing: url))
                
                // store in core data
                let (data, _) = try await URLSession.shared.data(from: URL(string: url)!)
                collectionViewModel.addNewImage(image: UIImage(data: data)!)
            }
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
        generationViewModel.isDownloaded = true
        generationViewModel.imagePrompt = nil
    }
    
    func generateVariations(collectionViewModel: CollectionsViewModel, generationViewModel: GenerationViewModel, url: String) async {
        do {
            let (data, _) = try await URLSession.shared.data(from: URL(string: url)!)
            let dataImage = generationViewModel.cropImageToSquare(image: UIImage(data: data)!)
            generationViewModel.imagePrompt = dataImage // the selected image appears above the textfield
            let response = try await generationViewModel.openAIClient?.images.createVariation(image: dataImage, n: 4)

            for url in response!.data.map(\.url) {
                // append each url retrieved from the api to the array of the url of generated images
                generationViewModel.generatedImages.append(String(describing: url))

                // store in core data
                let (data, _) = try await URLSession.shared.data(from: URL(string: url)!)
                collectionViewModel.addNewImage(image: UIImage(data: data)!)
            }
            generationViewModel.isDownloaded = true
            generationViewModel.imagePrompt = nil
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
    }
}
