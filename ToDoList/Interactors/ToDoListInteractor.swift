//
//  ToDoListInteractor.swift
//  ToDoList
//
//  Created by Kamil Biktineyev on 24.08.2024.
//

import Foundation

protocol ToDoListInteractorProtocol: AnyObject {
    var toDoItems: [ToDoItem] { get set }
    func countItemsInToDoList() -> Int
    func addToDoItem()
    func deleteToDoItem(index: Int)
    func changeStatusOfToDoItem(id: UUID)
    func saveToDoItemChanges(id: UUID, title: String)
    func filterToDoListByCreationDate()
    func fetchAPIToDoItems()
}

final class ToDoListInteractor: ToDoListInteractorProtocol {
    
    var toDoItems: [ToDoItem]
    
    weak var presenter: ToDoListPresenterProtocol?
    var networkManager: NetworkManagerProtocol
    var coreDataManager: CoreDataManagerProtocol
    
    init(presenter: ToDoListPresenterProtocol? = nil, networkManager: NetworkManagerProtocol, coreDataManager: CoreDataManagerProtocol) {
        self.toDoItems = coreDataManager.loadDataFromDB()
        self.presenter = presenter
        self.networkManager = networkManager
        self.coreDataManager = coreDataManager
        self.filterToDoListByCreationDate()
    }
    
    func countItemsInToDoList() -> Int {
        toDoItems.count
    }
    
    func addToDoItem() {
        DispatchQueue.global(qos: .userInteractive).async {
            let newToDoItem = ToDoItem(title: "")
            self.coreDataManager.saveDataToDB(toDoItem: newToDoItem)
            self.toDoItems.insert(newToDoItem, at: 0)
            DispatchQueue.main.async {
                self.presenter?.addToDoItemWithAnimation()
            }
        }
    }
    
    func deleteToDoItem(index: Int) {
        DispatchQueue.global(qos: .userInteractive).async {
            self.coreDataManager.deleteDataFromDB(toDoItem: self.toDoItems[index])
            self.toDoItems.remove(at: index)
            DispatchQueue.main.async {
                self.presenter?.deleteToDoItemWithAnimation(row: index)
            }
        }
    }
    
    func changeStatusOfToDoItem(id: UUID) {
        DispatchQueue.global(qos: .userInteractive).async {
            guard let index = self.toDoItems.firstIndex(where: { $0.id == id }) else {
                return
            }
            self.toDoItems[index].isCompleted.toggle()
            self.coreDataManager.saveChangesToDB(toDoItem: self.toDoItems[index])
            self.filterToDoListByCreationDate()
            DispatchQueue.main.async {
                self.presenter?.reloadToDoList()
            }
        }
    }
    
    func saveToDoItemChanges(id: UUID, title: String) {
        DispatchQueue.global(qos: .userInteractive).async {
            guard let index = self.toDoItems.firstIndex(where: { $0.id == id }) else {
                return
            }
            self.toDoItems[index].title = title
            self.coreDataManager.saveChangesToDB(toDoItem: self.toDoItems[index])
        }
    }
    
    func filterToDoListByCreationDate() {
        self.toDoItems.sort {
            if $0.isCompleted != $1.isCompleted {
                return !$0.isCompleted
            }
            return $0.dateOfCreation > $1.dateOfCreation
        }
    }
    
    func fetchAPIToDoItems() {
        guard toDoItems.count == 0 else { return }
        networkManager.fetchToDoItems { [weak self] apiToDoItems in
            guard let self = self else { return }
            var newToDoItems: [ToDoItem] = []
            for apiToDoItem in apiToDoItems {
                let newToDoItem = ToDoItem(fromAPItoDoItem: apiToDoItem)
                self.coreDataManager.saveDataToDB(toDoItem: newToDoItem)
                newToDoItems.append(newToDoItem)
            }
            self.toDoItems = newToDoItems
            self.filterToDoListByCreationDate()
            DispatchQueue.main.async {
                self.presenter?.reloadToDoList()
            }
        }
    }
}
