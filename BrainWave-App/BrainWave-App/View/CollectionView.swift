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
            VStack {
                Image(systemName: "face.smiling")
                Text("Work in progress...")
            }
        }
        .navigationTitle("My Collection")
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
    }
}
