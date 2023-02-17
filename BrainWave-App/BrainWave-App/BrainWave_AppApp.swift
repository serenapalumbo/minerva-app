//
//  BrainWave_AppApp.swift
//  BrainWave-App
//
//  Created by Marco Dell'Isola on 17/02/23.
//

import SwiftUI

@main
struct BrainWave_AppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
