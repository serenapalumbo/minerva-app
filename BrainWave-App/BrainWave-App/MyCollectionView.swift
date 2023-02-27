//
//  MyCollectionView.swift
//  BrainWave-App
//
//  Created by benedetta on 23/02/23.
//

import SwiftUI

struct MyCollectionView: View {
    var body: some View {
        
        NavigationStack{
            
            VStack {
                Image(systemName: "face.smiling")
                Text("Work in progress...")
            }
        }
        .navigationTitle("My Collection")
    }
}

struct MyCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        MyCollectionView()
    }
}
