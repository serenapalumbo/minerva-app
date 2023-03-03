//
//  CollectionView.swift
//  BrainWave-App
//
//  Created by Marco Dell'Isola on 27/02/23.
//

import SwiftUI

struct CollectionView: View {
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
        VStack(alignment: .leading) {
            ScrollView(.horizontal) {
                HStack {
                    Button {
                        // logic of adding folder (ux?)
                        //                            collectionViewModel.addNewFolder(name: "Name")
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
                            Text("Add")
                        }
                    }
                    if !collectionViewModel.folders.isEmpty {
                        ForEach(collectionViewModel.folders) { folder in
                            FolderView(name: folder.name!)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal)
            }
            
            VStack(alignment: .leading) {
                Text("All")
                    .font(.title)
                    .fontWeight(.bold)
                ScrollView {
                    if !collectionViewModel.images.isEmpty {
                        ScrollView {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 4), spacing: 10) {
                                ForEach(collectionViewModel.images) { image in
                                    Image(uiImage: UIImage(data: image.image!)!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: dimImages, height: dimImages)
                                        .clipped()
                                }
                            }
                        }
                    } else {
                        Text("No images generated")
                            .opacity(0.5)
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.horizontal)
            Spacer()
        }
        .navigationTitle("My Collection")
    }
}

// The preview crashes because it doesn't recognize data stored in Core Data
struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
    }
}
