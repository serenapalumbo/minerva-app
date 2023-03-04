//
//  ExtensionView.swift
//  BrainWave-App
//
//  Created by benedetta on 23/02/23.
//

import OpenAIKit
import SwiftUI

struct PromptView: View {
    @EnvironmentObject var generationViewModel: GenerationViewModel
    @EnvironmentObject var collectionViewModel: CollectionsViewModel
    var body: some View {
        VStack {
            if generationViewModel.imagePrompt != nil {
                Image(uiImage: UIImage(data: generationViewModel.imagePrompt!)!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(.bottom, 30)
            }
            HStack {
                HStack {
                    TextField("Write a prompt...", text: $generationViewModel.prompt)
                        .padding(10)
                    Image(systemName: "mic.fill")
                        .foregroundColor(.gray)
                        .padding(.trailing, 15)
                }
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("myGray"), lineWidth: 2))
                .background(Color("myGray"))
                .frame(width: generationViewModel.screenWidth * 0.7, height: generationViewModel.screenHeight * 0.04)
                .cornerRadius(10)
                Spacer()
                PickerView()
                Spacer()
                Button("Generate") {
                    generationViewModel.isLoading = false
                    generationViewModel.isDownloaded = false
                    if !generationViewModel.isLoading {
                        generationViewModel.isLoading = true
                        
                        // initialize as empty the array of generated images
                        generationViewModel.generatedImages.removeAll()
                        Task {
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
                                generationViewModel.isDownloaded = true
                                generationViewModel.imagePrompt = nil
                            } catch {
                                print("ERROR: \(error.localizedDescription)")
                            }
                        }
                    }
                }
                .frame(width: generationViewModel.screenWidth * 0.12, height: generationViewModel.screenHeight * 0.04)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .frame(width: generationViewModel.screenWidth * 0.87)
        }
    }
}

struct ResultView: View {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    @EnvironmentObject var generationViewModel: GenerationViewModel
    @EnvironmentObject var collectionViewModel: CollectionsViewModel
    var dimImages: CGFloat {
        if screenWidth > 1200 {
            return 300
        } else {
            return 256
        }
    }
    var paddingImages: CGFloat {
        if screenWidth > 1200 {
            return 20
        } else {
            return 5
        }
    }
    var body: some View {
        VStack(alignment: .leading) {
            Text("Results")
                .padding(.top, 20)
                .font(.system(size: 30))
                .bold()
            HStack {
                if !generationViewModel.isDownloaded {
                    ForEach(0..<4) {_ in
                        VStack {
                            Rectangle()
                                .fill(Color("myGray"))
                                .opacity(0.5)
                                .frame(width: dimImages, height: dimImages)
                                .overlay {
                                    if generationViewModel.isLoading {
                                        VStack {
                                            ProgressView()
                                        }
                                    }
                                }
                            
                            Button {
                                // empty
                            } label: {
                                ButtonVariation()
                            }
                        }
                    }
                    .padding(.trailing, paddingImages)
                } else {
                    ForEach(generationViewModel.generatedImages, id: \.self) { item in
                        VStack {
                            AsyncImage(url: URL(string: item)) { image in
                                image.resizable()
                            } placeholder: {
                                Rectangle()
                                    .fill(Color("myGray"))
                                    .opacity(0.5)
                                    .frame(width: dimImages, height: dimImages)
                                    .overlay {
                                        if generationViewModel.isLoading {
                                            VStack {
                                                ProgressView()
                                            }
                                        }
                                    }
                            }
                            .frame(width: dimImages, height: dimImages)
                            
                            Button {
                                Task {
                                    do {
                                        let (data, _) = try await URLSession.shared.data(from: URL(string: item)!)
                                        let dataImage = generationViewModel.cropImageToSquare(image: UIImage(data: data)!)
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
                                        
                                        print(response?.data.first?.url)
                                    } catch {
                                        print("ERROR: \(error.localizedDescription)")
                                    }
                                }
                            } label: {
                                ButtonVariation()
                            }
                        }
                    }
                    .padding(.trailing, paddingImages)
                }
            }
        }
    }
}

struct ButtonVariation: View {
    let screenWidth = UIScreen.main.bounds.width
    var dimImages: CGFloat {
        if screenWidth > 1200 {
            return 300
        } else {
            return 256
        }
    }
    var body: some View {
        Button {
            // action
        } label: {
            Text("Variations")
        }
        .frame(width: dimImages, height: 32.93)
        .background(Color.accentColor)
        .cornerRadius(10)
        .bold()
        .foregroundColor(.white)
    }
}

struct ButtonCollection: View {
    @EnvironmentObject var generationViewModel: GenerationViewModel
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(ImagePaint(image: Image("background1")))
                .frame(width: generationViewModel.screenWidth * 0.87, height: generationViewModel.screenHeight * 0.1)
                .scaledToFit()
                .cornerRadius(20)
            Text("My Collection")
                .font(.title)
                .font(.system(size: 42.04))
                .bold()
                .foregroundColor(.white)
                .padding(.horizontal)
                .shadow(radius: 5)
        }
        .padding(.bottom, 30)
    }
}

struct View_Previews: PreviewProvider {
    static var previews: some View {
        PromptView().environmentObject(GenerationViewModel())
        ButtonCollection().environmentObject(GenerationViewModel())
        ResultView().environmentObject(GenerationViewModel())
    }
}
