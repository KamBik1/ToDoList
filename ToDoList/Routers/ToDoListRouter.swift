//
//  ToDoListRouter.swift
//  ToDoList
//
//  Created by Kamil Biktineyev on 24.08.2024.
//

import Foundation
import UIKit

protocol ToDoListRouterProtocol: AnyObject {
    func showAlert(title: String, message: String, indexPath: IndexPath)
}

final class ToDoListRouter: ToDoListRouterProtocol {
    
    weak var view: ToDoListViewControllerProtocol?
    
    init(view: ToDoListViewControllerProtocol? = nil) {
        self.view = view
    }
    
    func showAlert(title: String, message: String, indexPath: IndexPath) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.view?.focusOnCell(indexPath: indexPath)
        }
        alert.addAction(okButton)
        view?.presentAlert(alert: alert)
    }
}
