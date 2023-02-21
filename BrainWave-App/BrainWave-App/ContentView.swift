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
    @State private var image: UIImage? = nil
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
                        
                        if let url = response.data.map(\.url).first {
                            let (data, _) = try await URLSession.shared.data(from: url)
                            image = UIImage(data: data)
                            isLoading = false
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            
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
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
