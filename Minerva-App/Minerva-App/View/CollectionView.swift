//
//  CollectionView.swift
//  BrainWave-App
//
//  Created by Marco Dell'Isola on 27/02/23.
//

import SwiftUI

struct CollectionView: View {
    @EnvironmentObject var collectionViewModel: CollectionsViewModel
    @State private var folderName: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
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
                    }
                    if !collectionViewModel.folders.isEmpty {
                        ForEach(collectionViewModel.folders.reversed()) { folder in
                            NavigationLink {
                                FolderImagesView(folder: folder)
                            } label: {
                                FolderView(folder: folder)
                            }
                            .contextMenu {
                                Button(role: .destructive) {
                                    collectionViewModel.folderId = folder.id
                                    // show an alert to ask for confirmation
                                    collectionViewModel.showingDeleteFolderAlert = true
                                } label: {
                                    Image(systemName: "trash")
                                    Text(LocalizedStringKey("delete"))
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal)
            }
            
            VStack(alignment: .leading) {
                Text(LocalizedStringKey("all"))
                    .font(.title)
                    .fontWeight(.bold)
                ScrollView {
                    if !collectionViewModel.images.isEmpty {
                        ScrollView {
                            ImagesGridView(imagesToShow: collectionViewModel.images.reversed())
                        }
                    } else {
                        Text(LocalizedStringKey("noimagegenerated"))
                            .opacity(0.5)
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.horizontal)
            Spacer()
        }
        .navigationTitle(LocalizedStringKey("mycollection"))
        .alert(LocalizedStringKey("newfolder"), isPresented: $collectionViewModel.isAddingFolder) {
            TextField(LocalizedStringKey("foldername"), text: $folderName)
            Button(LocalizedStringKey("cancel"), role: .cancel) { }
            Button(LocalizedStringKey("add")) {
                collectionViewModel.addNewFolder(name: folderName)
            }
        } message: {
            Text(LocalizedStringKey("enterfoldername"))
        }
        .alert(Text(LocalizedStringKey("suretodelete")), isPresented: $collectionViewModel.showingDeleteFolderAlert) {
            Button(LocalizedStringKey("delete"), role: .destructive) {
                // the selected folder is deleted
                collectionViewModel.deleteFolder(id: collectionViewModel.folderId!)
            }
            Button(LocalizedStringKey("cancel"), role: .cancel) { }
        }
    }
}

struct ImagesGridView: View {
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
    let imagesToShow: [ImageEntity]
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 4), spacing: 10) {
            ForEach(imagesToShow) { image in
                Image(uiImage: UIImage(data: image.image!)!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: dimImages, height: dimImages)
                    .clipped()
                    .contextMenu {
                        Button {
                            collectionViewModel.imageId = image.id
                            // Core data function to add to new folder
                            collectionViewModel.isAddingImageToFolder = true
                        } label: {
                            Image(systemName: "rectangle.stack.badge.plus")
                            Text(LocalizedStringKey("addtofolder"))
                        }
                        
//                        Button {
//                            collectionViewModel.imageId = image.id
//                            // Core data function to add to Favorites
//                        } label: {
//                            Image(systemName: "heart")
//                            Text(LocalizedStringKey("favourite"))
//                        }

                        Button {
                            collectionViewModel.imageId = image.id
                            guard let inputImage = UIImage(data: image.image!) else { return }
                            let imageSaver = ImageSaver()
                            imageSaver.writeToPhotoAlbum(image: inputImage)
                        } label: {
                            Image(systemName: "square.and.arrow.down")
                            Text(LocalizedStringKey("save"))
                        }
                        
                        Button(role: .destructive) {
                            collectionViewModel.imageId = image.id
                            // show an alert to ask for confirmation
                            collectionViewModel.showingDeleteAlert = true
                        } label: {
                            Image(systemName: "trash")
                            Text(LocalizedStringKey("delete"))
                        }
                    }
                    .alert(LocalizedStringKey("suretodelete"), isPresented: $collectionViewModel.showingDeleteAlert) {
                        Button(LocalizedStringKey("delete"), role: .destructive) {
                            // the selected image is deleted
                            collectionViewModel.deleteImage(id: collectionViewModel.imageId!)
                        }
                        Button(LocalizedStringKey("cancel"), role: .cancel) { }
                    } message: {
                        Text(LocalizedStringKey("oncedeleted"))
                    }
                    .sheet(isPresented: $collectionViewModel.isAddingImageToFolder) {
                        AddImageToFolderModal(imageId: collectionViewModel.imageId!)
                    }
            }
        }
    }
}

// The preview crashes because it doesn't recognize data stored in Core Data
struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
    }
}
