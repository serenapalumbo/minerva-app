//
//  ContentView.swift
//  BrainWave-App
//
//  Created by Marco Dell'Isola on 17/02/23.
//

import CoreData
import SwiftUI

struct ContentView: View {
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    @EnvironmentObject var generationViewModel: GenerationViewModel
    @StateObject var collectionViewModel = CollectionsViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Spacer(minLength: 50)
                    ButtonCollection()
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
        .onTapGesture {
            self.dismissKeyboard()
        }
        .environmentObject(collectionViewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(GenerationViewModel())
    }
}
