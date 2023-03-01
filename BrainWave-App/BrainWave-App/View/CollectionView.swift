//
//  CollectionView.swift
//  BrainWave-App
//
//  Created by Marco Dell'Isola on 27/02/23.
//

import SwiftUI

struct CollectionView: View {
    @EnvironmentObject var collectionViewModel: CollectionsViewModel
    var body: some View {
        NavigationStack {
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
                    ScrollView(.horizontal) {
                        if !collectionViewModel.images.isEmpty {
                            HStack {
                                ForEach(collectionViewModel.images) { image in
                                    Image(uiImage: UIImage(data: image.image!)!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 300, height: 220)
                                        .clipped()
                                }
                            }
                        } else {
                            Text("No images generated")
                        }
                    }
                }
                .padding(.horizontal)
                Spacer()
            }
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
