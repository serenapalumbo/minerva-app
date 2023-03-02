//
//  ContentView.swift
//  BrainWave-App
//
//  Created by Marco Dell'Isola on 17/02/23.
//

import CoreData
import SwiftUI

struct ContentView: View {
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    @EnvironmentObject var generationViewModel: GenerationViewModel
    var imageVariation = DallEImageGenerator.shared

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Button("Ciao") {
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
                    }
                    Spacer(minLength: 50)
                    ButtonCollection()
                    Spacer(minLength: 80)
                    PromptView()
                    Spacer(minLength: 100)
                    ResultView()
                }
            }
            .padding(.horizontal, 30)
            .navigationTitle("Create")
            .ignoresSafeArea(.keyboard)
        }
        .onTapGesture {
            self.dismissKeyboard()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(GenerationViewModel())
    }
}
