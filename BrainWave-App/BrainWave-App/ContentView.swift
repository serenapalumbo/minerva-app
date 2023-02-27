//
//  ContentView.swift
//  BrainWave-App
//
//  Created by Marco Dell'Isola on 17/02/23.
//

import CoreData
import SwiftUI


struct ContentView: View {
    
    @State private var suggestionsAreStatic = true
    
    func dismissKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    
    let apiKey = "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" // TODO: logic of retrieving the api key
    
    @State private var prompt = ""
    //    @State private var generatedImages: [UIImage] = []
    @State private var generatedImages: [String] = []
    @State private var isLoading = false
    @State private var isDownloaded = false
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
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
    
    @State var suggestions = [
        "Ginger woman in popArt style","Strawberry shaped chair","Astronaut on the moon in Monet-style", "prova 1", "prova 2", "prova 3", "prova 4", "prova 5", "prova 6"
    ]
    
    
    
    var body: some View {
        
        
        
        NavigationStack {
            
            ScrollView {
                VStack(alignment: .leading){
                HStack {
                    TextField("Enter prompt...", text: $prompt)
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
//                    .buttonStyle(.borderedProminent)
                    
                }.navigationTitle("Create")
                .ignoresSafeArea(.keyboard)
                .padding(.top,16)
                Spacer()
                
                ButtonCollection()
                    .padding(.top, 40)
                VStack(alignment: .leading){
                    Text("Results")
                        .padding(.top, 20)
                        .font(.title2)
                        .bold()
                    //  .padding(.leading, 16)
                    HStack {
                        if !isDownloaded {
                            ForEach(0..<4) {_ in
                                Rectangle()
                                    .fill(Color("myGray"))
                                    .opacity(0.5)
                                    .frame(width: dimImages, height: dimImages)
                                    .overlay {
                                        if isLoading {
                                            VStack {
                                                ProgressView()
                                            }
                                        }
                                    }
                            }
                              .padding(.trailing, paddingImages)
                        } else {
                            ForEach(generatedImages, id: \.self) { item in
                                AsyncImage(url: URL(string: item)) { image in
                                    image.resizable()
                                } placeholder: {
                                    Rectangle()
                                        .fill(Color("myGray"))
                                        .opacity(0.5)
                                        .frame(width: dimImages, height: dimImages)
                                        .overlay {
                                            if isLoading {
                                                VStack {
                                                    ProgressView()
                                                }
                                            }
                                        }
                                }

                                .frame(width: dimImages, height: dimImages)

                            }
                            .padding(.trailing, paddingImages)
                        }

                    }
                }
//                .padding(.horizontal, 31)
                Spacer()
                
//                ButtonCollection()
//                    .padding(.top, 40)
            }
            }
            .padding(.horizontal, 30)
//                .scrollDisabled(true)
//            .scrollDismissesKeyboard(.immediately)
        }
        .onTapGesture {
                    self.dismissKeyboard()
                }
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
