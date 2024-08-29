//
//  NetworkManagerMock.swift
//  ToDoListTests
//
//  Created by Kamil Biktineyev on 28.08.2024.
//

@testable import ToDoList

final class NetworkManagerMock: NetworkManagerProtocol {
    
    func fetchToDoItems(completion: @escaping ([ToDoList.APItoDoItem]) -> Void) {
        let toDoItems: [APItoDoItem] = [
            APItoDoItem(todo: "Learn calligraphy", completed: false),
            APItoDoItem(todo: "Draw a picture", completed: false)
        ]
        return completion(toDoItems)
    }
}
