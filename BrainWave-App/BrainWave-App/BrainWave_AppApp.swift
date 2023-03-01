//
//  BrainWave_AppApp.swift
//  BrainWave-App
//
//  Created by Marco Dell'Isola on 17/02/23.
//

import SwiftUI

@main
struct BrainWave_AppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(GenerationViewModel())
        }
    }
}
