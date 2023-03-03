//
//  ExtensionView.swift
//  BrainWave-App
//
//  Created by benedetta on 23/02/23.
//

import SwiftUI

struct PromptView: View {
    @EnvironmentObject var generationViewModel: GenerationViewModel
    @EnvironmentObject var collectionViewModel: CollectionsViewModel
    var body: some View {
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
                            let response = try await generationViewModel.openAIClient?.images.create(prompt: generationViewModel.prompt, n: 4)
                            print(response!.data.first?.url)
                            for url in response!.data.map(\.url) {
                                // append each url retrieved from the api to the array of the url of generated images
                                generationViewModel.generatedImages.append(String(describing: url))
                                
                                let (data, _) = try await URLSession.shared.data(from: URL(string: url)!)
                                collectionViewModel.addNewImage(image: UIImage(data: data)!)
                            }
                        } catch {
                            print("ERROR: \(error)")
                        }
                    }
                    
                    generationViewModel.isDownloaded = true
                }
            }
            .frame(width: generationViewModel.screenWidth * 0.12, height: generationViewModel.screenHeight * 0.04)
            .background(Color(red: 0.6901960784313725, green: 0.5803921568627451, blue: 0.8941176470588236))
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .frame(width: generationViewModel.screenWidth * 0.87)
    }
}

struct ResultView: View {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    @EnvironmentObject var generationViewModel: GenerationViewModel
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
                            Button("Variation") {
                                Task {
                                    do {
                                        //                                try await imageVariation.createVariations(imageName: "ss")
                                        let imageURL = URL(string: "https://oaidalleapiprodscus.blob.core.windows.net/private/org-zZXwenkqkE989XS1fTRV732A/user-JfcoSEVj9ELPvEw7fphu15PY/img-orL5sRxwdgBVpCVtBFeJhdf1.png?st=2023-03-02T14%3A31%3A54Z&se=2023-03-02T16%3A31%3A54Z&sp=r&sv=2021-08-06&sr=b&rscd=inline&rsct=image/png&skoid=6aaadede-4fb3-4698-a8f6-684d7786b067&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2023-03-02T05%3A57%3A38Z&ske=2023-03-03T05%3A57%3A38Z&sks=b&skv=2021-08-06&sig=YlMcSqc//Iewf5EmXRiLGGf0duVnx7ACWiYiTIuMdYQ%3D")
                                        let (dataImage, _) = try await URLSession.shared.data(from: imageURL!)
                                        
                                        let response = try await generationViewModel.openAIClient?.images.createVariation(image: dataImage)
                                        print(response!.data.first?.url)
                                    } catch {
                                        print("ERROR: \(error)")
                                    }
                                }
                            }.frame(width: dimImages, height: 32.93)
                                .background(Color(red: 0.6901960784313725, green: 0.5803921568627451, blue: 0.8941176470588236))
                                .cornerRadius(10)
                                .bold()
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.trailing, paddingImages)
                }
            }
        }
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
                        .padding([.leading, .top])
                        .shadow(radius: 5)
                }
            
        
    }
}

struct View_Previews: PreviewProvider {
    static var previews: some View {
        PromptView().environmentObject(GenerationViewModel())
        ButtonCollection().environmentObject(GenerationViewModel())
        ResultView().environmentObject(GenerationViewModel())
    }
}
