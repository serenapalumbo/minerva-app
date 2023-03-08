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

struct AddImageToFolderModal: View {
    @EnvironmentObject var collectionViewModel: CollectionsViewModel
    var folderPerRow = 3
    let imageId: UUID
    var image: ImageEntity {
        return collectionViewModel.images.first(where: { $0.id == imageId })!
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Button {
                    collectionViewModel.isAddingFolder = true
                } label: {
                    VStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color("myGray"))
                            .opacity(0.5)
                            .frame(width: 180, height: 150)
                            .cornerRadius(15)
                            .overlay {
                                Image(systemName: "plus")
                                    .foregroundColor(Color.accentColor)
                                    .font(.system(size: 70))
                            }
                        Text(LocalizedStringKey("add"))
                    }
                }.padding(.bottom, 40)
                Text(LocalizedStringKey("myfolders"))
                    .font(.system(size: 30).bold())
                if !collectionViewModel.folders.isEmpty {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading) {
                            ForEach(0..<collectionViewModel.folders.count/folderPerRow + 1) { rowIndex in
                                HStack {
                                    folderRow(for: rowIndex)
                                }
                            }
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Cancel") {
                    collectionViewModel.isAddingImageToFolder = false
                }
                .padding(.top, 20)
            }
            ToolbarItem(placement: .principal) {
                Text("Add to Folder")
                    .font(.system(size: 20).bold())
            }
        }
    }

    func folderButton(for folderIndex: Int) -> some View {
        Button {
            collectionViewModel.addToFolder(image: image, folder: collectionViewModel.folders[folderIndex])
            collectionViewModel.isAddingImageToFolder = false
        } label: {
            FolderView(folder: collectionViewModel.folders[folderIndex])
        }
    }

    func folderRow(for rowIndex: Int) -> some View {
        let startIndex = rowIndex * folderPerRow
        let endIndex = min(startIndex + folderPerRow, collectionViewModel.folders.count)
        let folderIndices = startIndex..<endIndex

        return HStack {
            ForEach(folderIndices) { folderIndex in
                folderButton(for: folderIndex)
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
            Text(LocalizedStringKey("noimagegenerated"))
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
