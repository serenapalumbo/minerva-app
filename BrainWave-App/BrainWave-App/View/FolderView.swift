//
//  FolderView.swift
//  BrainWave-App
//
//  Created by Serena on 01/03/23.
//

import SwiftUI

struct FolderView: View {
    let name: String
    var body: some View {
        VStack(alignment: .leading) {
            Rectangle()
                .fill(Color("myGray"))
                .opacity(0.5)
                .frame(width: 180, height: 150)
                .cornerRadius(15)
            Text(name)
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

struct FolderView_Previews: PreviewProvider {
    static var previews: some View {
        FolderView(name: "Name")
    }
}
