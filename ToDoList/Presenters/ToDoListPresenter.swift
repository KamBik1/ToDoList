//
//  ToDoListPresenter.swift
//  ToDoList
//
//  Created by Kamil Biktineyev on 24.08.2024.
//

import Foundation

protocol ToDoListPresenterProtocol: AnyObject {
    func countItemsInToDoList() -> Int
    func reloadToDoList()
    func addToDoItemWithAnimation()
    func deleteToDoItemWithAnimation(row: Int)
    func fetchToDoItems() -> [ToDoItem]
    func addToDoItem()
    func deleteToDoItem(index: Int)
    func changeStatusOfToDoItem(id: UUID)
    func saveToDoItemChanges(id: UUID, title: String)
    func fetchAPIToDoItems()
    func showEmptyTitleAlert(title: String, message: String, indexPath: IndexPath)
}

final class ToDoListPresenter: ToDoListPresenterProtocol {
    
    weak var view: ToDoListViewControllerProtocol?
    var interactor: ToDoListInteractorProtocol
    var router: ToDoListRouterProtocol
    
    init(view: ToDoListViewControllerProtocol? = nil, interactor: ToDoListInteractorProtocol, router: ToDoListRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    
    // Методы для view
    func reloadToDoList() {
        view?.reloadToDoList()
    }
    
    func addToDoItemWithAnimation() {
        view?.addToDoItemWithAnimation()
    }
    
    func deleteToDoItemWithAnimation(row: Int) {
        view?.deleteToDoItemWithAnimation(row: row)
    }
    
    
    // Методы для interactor
    func countItemsInToDoList() -> Int {
        interactor.countItemsInToDoList()
    }
    
    func fetchToDoItems() -> [ToDoItem] {
        interactor.toDoItems
    }
    
    func addToDoItem() {
        interactor.addToDoItem()
    }
    
    func deleteToDoItem(index: Int) {
        interactor.deleteToDoItem(index: index)
    }
    
    func changeStatusOfToDoItem(id: UUID) {
        interactor.changeStatusOfToDoItem(id: id)
    }
    
    func saveToDoItemChanges(id: UUID, title: String) {
        interactor.saveToDoItemChanges(id: id, title: title)
    }
    
    func fetchAPIToDoItems() {
        interactor.fetchAPIToDoItems()
    }
    
    
    // Методы для router
    func showEmptyTitleAlert(title: String, message: String, indexPath: IndexPath) {
        router.showAlert(title: title, message: message, indexPath: indexPath)
    }
}
