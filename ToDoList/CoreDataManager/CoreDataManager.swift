//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by Kamil Biktineyev on 24.08.2024.
//

import Foundation
import CoreData

protocol CoreDataManagerProtocol: AnyObject {
    func saveDataToDB(toDoItem: ToDoItem)
    func saveChangesToDB(toDoItem: ToDoItem)
    func loadDataFromDB() -> [ToDoItem]
    func deleteDataFromDB(toDoItem: ToDoItem)
}

final class CoreDataManager: CoreDataManagerProtocol {
    static let shared = CoreDataManager()
    
    private init() {}
    
    var veiwContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // Определяем метод для сохраения новой toDoItem в DataBase
    func saveDataToDB(toDoItem: ToDoItem) {
        let toDotemEntity = ToDoItemEntity(context: veiwContext)
        toDotemEntity.id = toDoItem.id
        toDotemEntity.title = toDoItem.title
        toDotemEntity.dateOfCreation = toDoItem.dateOfCreation
        toDotemEntity.dateOfCreationString = toDoItem.dateOfCreationString
        toDotemEntity.isCompleted = toDoItem.isCompleted
        saveContext()
    }
    
    // Определяем метод для сохраения изменений toDoItem в DataBase
    func saveChangesToDB(toDoItem: ToDoItem) {
        let fetchRequest = ToDoItemEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", "\(toDoItem.id)")
        let toDoItemsEntities = try? veiwContext.fetch(fetchRequest)
        guard let toDoItemsEntities = toDoItemsEntities else {
            return print("Changes didn't save to DB")
        }
        toDoItemsEntities[0].title = toDoItem.title
        toDoItemsEntities[0].isCompleted = toDoItem.isCompleted
        saveContext()
    }
    
    // Определяем метод для загрузки toDoItems из DataBase
    func loadDataFromDB() -> [ToDoItem] {
        let fetchRequest = ToDoItemEntity.fetchRequest()
        let toDoItemsEntities = try? veiwContext.fetch(fetchRequest)
        guard let toDoItemsEntities = toDoItemsEntities else {
            print("Data didn't load from DB")
            return []
        }
        var result: [ToDoItem] = []
        toDoItemsEntities.forEach { toDoItemEntity in
            let toDoItem = ToDoItem(managedObject: toDoItemEntity)
            guard let toDoItem = toDoItem else { return }
            result.append(toDoItem)
        }
        return result
    }

    // Определяем метод для удаления toDoItem из DataBase
    func deleteDataFromDB(toDoItem: ToDoItem) {
        let fetchRequest = ToDoItemEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", "\(toDoItem.id)")
        let toDoItemsEntities = try? veiwContext.fetch(fetchRequest)
        guard let toDoItemsEntities = toDoItemsEntities else {
            return print("Data didn't delete from DB")
        }
        veiwContext.delete(toDoItemsEntities[0])
        saveContext()
    }
}
