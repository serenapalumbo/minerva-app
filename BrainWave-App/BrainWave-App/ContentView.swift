//
//  ContentView.swift
//  BrainWave-App
//
//  Created by Marco Dell'Isola on 17/02/23.
//

import CoreData
import SwiftUI

struct ContentView: View {
    let apiKey = "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" // TODO: logic of retrieving the api key
    
    @State private var prompt = ""
//    @State private var generatedImages: [UIImage] = []
    @State private var generatedImages: [String] = []
    @State private var isLoading = false
    @State private var isDownloaded = false
    
    var body: some View {
        VStack {
            TextField("Enter prompt...", text: $prompt, axis: .vertical)
                .textFieldStyle(.roundedBorder)
            
            Button("Generate") {
                isLoading = false
                isDownloaded = false
                if !isLoading {
                    isLoading = true
                    Task {
                        do {
                            generatedImages.removeAll()
                            let response = try await DallEImageGenerator.shared.generateImage(withPrompt: prompt, apiKey: apiKey)
                            
                            for url in response.data.map(\.url) {
                                // append each url retrieved from the api to the array of the url of generated images
                                generatedImages.append(String(describing: url))
                            }
                            
                            isDownloaded = true
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            
            HStack {
                if !isDownloaded {
                    ForEach(0..<4) {_ in
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: 256, height: 256)
                            .overlay {
                                if isLoading {
                                    VStack {
                                        ProgressView()
                                    }
                                }
                            }
                    }
                } else {
                    ForEach(generatedImages, id: \.self) { item in
                        AsyncImage(url: URL(string: item)) { image in
                            image.resizable()
                        } placeholder: {
                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: 256, height: 256)
                                .overlay {
                                    if isLoading {
                                        VStack {
                                            ProgressView()
                                        }
                                    }
                                }
                        }
                        .frame(width: 256, height: 256)
                    }
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
