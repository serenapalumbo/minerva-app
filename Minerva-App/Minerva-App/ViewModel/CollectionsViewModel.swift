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
    @Published var isAddingFolder = false
    @Published var showingDeleteAlert = false
    @Published var showingDeleteFolderAlert = false
    @Published var isAddingImageToFolder = false
    @Published var imageId: UUID?
    @Published var folderId: UUID?
    
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
    
//    func deleteImage(image: ImageEntity) {
//        PersistenceManager.shared.container.viewContext.delete(image)
//        saveChanges()
//    }
    
    func deleteImage(id: UUID) {
        PersistenceManager.shared.container.viewContext.delete(images.first(where: { $0.id == id })!)
        saveChanges()
    }
    
    func addToFolder(image: ImageEntity, folder: FolderEntity) {
        folder.addToImages(image)
        image.addToFolders(folder)
        saveChanges()
    }
    
    func addNewFolder(name: String) {
        let newFolder = FolderEntity(context: PersistenceManager.shared.container.viewContext)
        newFolder.id = UUID()
        newFolder.name = name
        saveChanges()
    }
    
    func deleteFolder(id: UUID) {
        PersistenceManager.shared.container.viewContext.delete(folders.first(where: { $0.id == id })!)
        saveChanges()
    }
    
//    func deleteFolder(folder: FolderEntity) {
//        PersistenceManager.shared.container.viewContext.delete(folder)
//        saveChanges()
//    }
    
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

class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
    }
}
