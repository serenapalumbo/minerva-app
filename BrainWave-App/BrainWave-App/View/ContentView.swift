//
//  ContentView.swift
//  BrainWave-App
//
//  Created by Marco Dell'Isola on 17/02/23.
//

import CoreData
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var generationViewModel: GenerationViewModel
    @StateObject var collectionViewModel = CollectionsViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Spacer(minLength: 50)
                    NavigationLink(destination: CollectionView()) {
                        ButtonCollection()
                    }
                    Spacer(minLength: 80)
                    PromptView()
                    Spacer(minLength: 100)
                    ResultView()
                }
            }
            .padding(.horizontal, 30)
            .navigationTitle("Create")
            .ignoresSafeArea(.keyboard)
        }
        .environmentObject(collectionViewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(GenerationViewModel())
    }
}
