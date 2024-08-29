//
//  ToDoItem.swift
//  ToDoList
//
//  Created by Kamil Biktineyev on 24.08.2024.
//

import Foundation
import CoreData

struct ToDoItem: Equatable {
    var id: UUID
    var title: String
    var dateOfCreation: Date
    var dateOfCreationString: String
    var isCompleted: Bool = false
    
    init(title: String) {
        self.id = UUID()
        self.title = title
        self.dateOfCreation = Date()
        self.dateOfCreationString = ToDoItem.currentDateString()
        self.isCompleted = false
    }
    
    private static func currentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter.string(from: Date())
    }
}

extension ToDoItem {
    // Инициализатор, который преобразует модель от API в ToDoItem
    init(fromAPItoDoItem apiToDoItem: APItoDoItem) {
        self.id = UUID()
        self.title = apiToDoItem.todo
        self.dateOfCreation = Date()
        self.dateOfCreationString = ToDoItem.currentDateString()
        self.isCompleted = apiToDoItem.completed
    }
}


extension ToDoItem {
    // Инициализатор, который преобразует NSManagedObject в ToDoItem
    init?(managedObject: NSManagedObject) {
        guard let id = managedObject.value(forKey: "id") as? UUID,
              let title = managedObject.value(forKey: "title") as? String,
              let dateOfCreation = managedObject.value(forKey: "dateOfCreation") as? Date,
              let dateOfCreationString = managedObject.value(forKey: "dateOfCreationString") as? String,
              let isCompleted = managedObject.value(forKey: "isCompleted") as? Bool else {
            return nil
        }
        self.id = id
        self.title = title
        self.dateOfCreation = dateOfCreation
        self.dateOfCreationString = dateOfCreationString
        self.isCompleted = isCompleted
    }
}
