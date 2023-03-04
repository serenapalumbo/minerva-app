//
//  PickerView.swift
//  BrainWave-App
//
//  Created by Serena on 02/03/23.
//

import PhotosUI
import SwiftUI

struct PickerView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @EnvironmentObject var generationViewModel: GenerationViewModel
    
    var body: some View {
        VStack {
            PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                Image(systemName: "photo")
                    .foregroundColor(.gray)
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    // Retrieve selected asset in the form of Data
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        selectedImageData = data
                        let uiImage = UIImage(data: selectedImageData!)!
                        generationViewModel.imagePrompt = generationViewModel.cropImageToSquare(image: uiImage)
                    }
                }
            }
        }
    }
}

struct PickerView_Previews: PreviewProvider {
    static var previews: some View {
        PickerView()
    }
}
