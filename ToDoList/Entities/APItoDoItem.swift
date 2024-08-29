//
//  APItoDoItem.swift
//  ToDoList
//
//  Created by Kamil Biktineyev on 27.08.2024.
//

import Foundation

struct APIresponse: Decodable {
    let todos: [APItoDoItem]
    let total: Int
}

struct APItoDoItem: Decodable {
    let todo: String
    let completed: Bool
}
