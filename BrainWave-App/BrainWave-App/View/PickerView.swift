//
//  PickerView.swift
//  BrainWave-App
//
//  Created by Serena on 02/03/23.
//

import PhotosUI
import SwiftUI

struct PickerView: View {
    func cropImageToSquare(image: UIImage) -> Data {
        let size = min(image.size.width, image.size.height)
        let originX = (image.size.width - size) / 2
        let originY = (image.size.height - size) / 2
        let cropRect = CGRect(x: originX, y: originY, width: size, height: size)
        let croppedImage = (image.cgImage?.cropping(to: cropRect))!
        let resizedImage = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512)).image { _ in
            UIImage(cgImage: croppedImage).draw(in: CGRect(x: 0, y: 0, width: 512, height: 512))
        }
        var compressionQuality: CGFloat = 0.8 // Initial compression quality
        var imageData = resizedImage.jpegData(compressionQuality: compressionQuality)
        
        // Keep compressing until the image size is under 4 MB
        while imageData?.count ?? 0 > 40_000 {
            compressionQuality -= 0.1
            guard compressionQuality > 0 else { return UIImage(data: imageData!)!.pngData()! }
            imageData = resizedImage.jpegData(compressionQuality: compressionQuality)
        }
        
        return UIImage(data: imageData!)!.pngData()!
    }
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @EnvironmentObject var generationViewModel: GenerationViewModel
    
    var body: some View {
        VStack {
            PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                Image(systemName: "arrow.up.to.line")
                    .foregroundColor(.gray)
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    // Retrieve selected asset in the form of Data
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        selectedImageData = data
                        let uiImage = UIImage(data: selectedImageData!)!
                        generationViewModel.imagePrompt = cropImageToSquare(image: uiImage)
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
