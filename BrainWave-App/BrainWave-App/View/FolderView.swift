//
//  FolderView.swift
//  BrainWave-App
//
//  Created by Serena on 01/03/23.
//

import SwiftUI

struct FolderView: View {
    let folder: FolderEntity
    var images: [ImageEntity] {
        // convert the NSSet of images connected to a folder to an array of ImageEntity
        return (folder.images?.allObjects as? [ImageEntity])!
    }
    @State var coverData: Data?
    
    var body: some View {
        VStack(alignment: .leading) {
            Rectangle()
                .fill(Color("myGray"))
                .opacity(0.5)
                .overlay {
                    if coverData != nil {
                        Image(uiImage: UIImage(data: coverData!)!)
                            .resizable()
                            .scaledToFill()
                    }
                }
                .frame(width: 180, height: 150)
                .cornerRadius(15)
            
            Text(folder.name!)
        }
        .foregroundColor(.primary)
        .onAppear {
            if let image = images.first {
                coverData = image.image
            }
        }
    }
}

struct AddFolderModal: View {
    @State private var folderName: String = ""
    @EnvironmentObject var collectionViewModel: CollectionsViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Folder Name", text: $folderName)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                Button("Add Folder") {
                    collectionViewModel.addNewFolder(name: folderName.isEmpty ? "New Folder" : folderName)
                    collectionViewModel.isAddingFolder = false
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        collectionViewModel.isAddingFolder = false
                    }
                }
            }
        }
    }
}

struct AddImageToFolderModal: View {
    @EnvironmentObject var collectionViewModel: CollectionsViewModel
    let imageId: UUID
    var image: ImageEntity {
        return collectionViewModel.images.first(where: { $0.id == imageId })!
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Image(uiImage: UIImage(data: image.image!)!)
                    .resizable()
                    .frame(width: 100, height: 100)
                
                ForEach(collectionViewModel.folders) { folder in
                    Button {
                        collectionViewModel.addToFolder(image: image, folder: folder)
                        collectionViewModel.isAddingImageToFolder = false
                    } label: {
                        FolderView(folder: folder)
                    }
                }
            }
            .navigationTitle("Add to Folder")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        collectionViewModel.isAddingImageToFolder = false
                    }
                }
            }
        }
    }
}

struct FolderImagesView: View {
    let folder: FolderEntity
    var images: [ImageEntity] {
        // convert the NSSet of images connected to a folder to an array of ImageEntity
        return (folder.images?.allObjects as? [ImageEntity])!
    }
    @EnvironmentObject var collectionViewModel: CollectionsViewModel
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    var dimImages: CGFloat {
        if screenWidth > 1200 {
            return 300
        } else {
            return 256
        }
    }
    var body: some View {
        if !collectionViewModel.images.isEmpty {
            ScrollView {
                ImagesGridView(imagesToShow: images)
            }
        } else {
            Text("No images generated")
                .opacity(0.5)
                .padding(.horizontal)
        }
    }
}

// struct FolderView_Previews: PreviewProvider {
//    static var previews: some View {
//        FolderView(name: "Name")
//    }
// }
