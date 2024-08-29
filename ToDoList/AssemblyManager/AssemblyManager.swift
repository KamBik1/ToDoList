//
//  AssemblyManager.swift
//  ToDoList
//
//  Created by Kamil Biktineyev on 24.08.2024.
//

import UIKit

protocol AssemblyManagerProtocol: AnyObject {
    static func createToDoListView() -> UIViewController
}

final class AssemblyManager: AssemblyManagerProtocol {
    // Определяем метод для создания основной view
    static func createToDoListView() -> UIViewController {
        let interactor = ToDoListInteractor(networkManager: NetworkManager(), coreDataManager: CoreDataManager.shared)
        let router = ToDoListRouter()
        let presenter = ToDoListPresenter(interactor: interactor, router: router)
        let view = ToDoListViewController(presenter: presenter)
        interactor.presenter = presenter
        presenter.view = view
        router.view = view
        return view
    }
}
