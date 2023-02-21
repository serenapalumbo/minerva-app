//
//  PersistenceManager.swift
//  BrainWave-App
//
//  Created by Serena on 21/02/23.
//

import Foundation
import Combine
import CoreData

struct PersistenceManager {
    static let shared = PersistenceManager()
    
    static var preview: PersistenceManager = {
        let result = PersistenceManager(inMemory: true)
        let viewContext = result.container.viewContext
        return result
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Collections")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func saveContext(completionHandler: @escaping (Error?) -> Void) {
        if PersistenceManager.shared.container.viewContext.hasChanges {
            do {
                try PersistenceManager.shared.container.viewContext.save()
                completionHandler(nil)
            } catch {
                completionHandler(error)
            }
        }
    }
}
