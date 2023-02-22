//
//  CollectionsViewModel.swift
//  BrainWave-App
//
//  Created by Serena on 21/02/23.
//

import CoreData
import Foundation
import UIKit

final class CollectionsViewModel: ObservableObject {
    @Published var images: [ImageEntity] = []
    @Published var folders: [FolderEntity] = []
    
    init() {
        fetchImages()
        fetchFolders()
    }
    
    func fetchImages() {
        let request = NSFetchRequest<ImageEntity>(entityName: "ImageEntity")
        
        do {
            images = try PersistenceManager.shared.container.viewContext.fetch(request)
        } catch {
            print("Error fetching. \(error)")
        }
    }
    
    func fetchFolders() {
        let request = NSFetchRequest<FolderEntity>(entityName: "FolderEntity")
        
        do {
            folders = try PersistenceManager.shared.container.viewContext.fetch(request)
        } catch {
            print("Error fetching. \(error)")
        }
    }
    
    func addNewImage(image: UIImage) {
        let newImage = ImageEntity(context: PersistenceManager.shared.container.viewContext)
        newImage.id = UUID()
        newImage.image = image.jpegData(compressionQuality: 50)
        saveChanges()
    }
    
    func deleteImage(image: ImageEntity) {
        PersistenceManager.shared.container.viewContext.delete(image)
        saveChanges()
    }
    
    func addNewFolder(name: String) {
        let newFolder = FolderEntity(context: PersistenceManager.shared.container.viewContext)
        newFolder.id = UUID()
        newFolder.name = name
        saveChanges()
    }
    
    func deleteFolder(folder: FolderEntity) {
        PersistenceManager.shared.container.viewContext.delete(folder)
        saveChanges()
    }
    
    func saveChanges() {
        PersistenceManager.shared.saveContext { error in
            guard error == nil else {
                print("An error occurred while saving: \(error!)")
                return
            }
            self.fetchImages()
            self.fetchFolders()
        }
    }
}
