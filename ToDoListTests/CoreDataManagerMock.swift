//
//  CoreDataManagerMock.swift
//  ToDoListTests
//
//  Created by Kamil Biktineyev on 28.08.2024.
//

@testable import ToDoList

final class CoreDataManagerMock: CoreDataManagerProtocol {
    
    func saveDataToDB(toDoItem: ToDoList.ToDoItem) {
        return
    }
    
    func saveChangesToDB(toDoItem: ToDoList.ToDoItem) {
        return
    }
    
    func loadDataFromDB() -> [ToDoList.ToDoItem] {
        return []
    }
    
    func deleteDataFromDB(toDoItem: ToDoList.ToDoItem) {
        return
    }
}
