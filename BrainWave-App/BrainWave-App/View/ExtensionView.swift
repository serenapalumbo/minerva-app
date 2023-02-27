//
//  MyCollectionView.swift
//  BrainWave-App
//
//  Created by benedetta on 23/02/23.
//

import SwiftUI

struct PromptView: View {
    @EnvironmentObject var generationViewModel: GenerationViewModel
    var body: some View {
        HStack{
            HStack {
                TextField("Write a prompt...", text: $generationViewModel.prompt)
                    .padding(10)
                Image(systemName: "mic.fill")
                    .foregroundColor(.gray)
                    .padding(.trailing, 15)
            }
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 0.937, green: 0.937, blue: 0.942), lineWidth: 2))
            .background(Color(red: 0.937, green: 0.937, blue: 0.942))
            .frame(width: 919.57, height: 37)
            .cornerRadius(10)
            Spacer()
            Image(systemName: "square.and.arrow.up")
                .foregroundColor(.gray)
            Spacer()
            Button("Generate") {
                generationViewModel.isLoading = false
                generationViewModel.isDownloaded = false
                if !generationViewModel.isLoading {
                    generationViewModel.isLoading = true
                    Task {
                        do {
                            generationViewModel.generatedImages.removeAll()
                            let response = try await DallEImageGenerator.shared.generateImage(withPrompt: generationViewModel.prompt)
                            for url in response.data.map(\.url) {
                                // append each url retrieved from the api to the array of the url of generated images
                                generationViewModel.generatedImages.append(String(describing: url))
                            }

                            generationViewModel.isDownloaded = true
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }.frame(width: 208.35, height: 35)
                .background(Color(red: 0.6901960784313725, green: 0.5803921568627451, blue: 0.8941176470588236))
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .frame(width: 1175)
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
                        VStack{
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
                                // TODO: Recall Variation function
                            }.frame(width: dimImages, height: dimImages)
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
    //    var dimHeightCollect: CGFloat {
    //        if generationViewModel.screenWidth > 1200 {
    //            return 200
    //        } else {
    //            return 150
    //        }
    //    }
    //    var dimWidthCollect: CGFloat {
    //        if generationViewModel.screenWidth > 1200 {
    //            return 1150
    //        } else {
    //            return 1000
    //        }
    //    }
    //    var paddingCollect: CGFloat {
    //        if generationViewModel.screenWidth > 1200 {
    //            return 120
    //        } else {
    //            return 100
    //        }
    //    }

    var body: some View {
        NavigationLink(destination: CollectionView()) {
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(ImagePaint(image: Image("b1")))
                    .frame(width: 1175 , height: 98.08)
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
}

struct View_Previews: PreviewProvider {
    static var previews: some View {
        ButtonCollection().environmentObject(GenerationViewModel())
        ResultView().environmentObject(GenerationViewModel())
    }
}
