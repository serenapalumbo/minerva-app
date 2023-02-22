//
//  ContentView.swift
//  BrainWave-App
//
//  Created by Marco Dell'Isola on 17/02/23.
//

import CoreData
import SwiftUI

struct ContentView: View {
    let apiKey = "API_KEY" // TODO: logic of retrieving the api key
    
    @State private var prompt = ""
    @State private var generatedImages: [UIImage] = []
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            TextField("Enter prompt...", text: $prompt, axis: .vertical)
                .textFieldStyle(.roundedBorder)
            
            Button("Generate") {
                isLoading = true
                Task {
                    do {
                        let response = try await DallEImageGenerator.shared.generateImage(withPrompt: prompt, apiKey: apiKey)
                        
                        for url in response.data.map(\.url) {
                            // encode each url retrieved from the api
                            let (data, _) = try await URLSession.shared.data(from: url)
                            // append the UIImage built by the url retrieved from the api to the array of generated images
                            generatedImages.append(UIImage(data: data)!)
                        }
                        
                        isLoading = false
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            
            HStack {
                ForEach(generatedImages, id: \.self) { image in
                    if let image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 256, height: 256)
                    } else {
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
