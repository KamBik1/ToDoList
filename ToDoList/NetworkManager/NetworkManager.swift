//
//  NetworkManager.swift
//  ToDoList
//
//  Created by Kamil Biktineyev on 24.08.2024.
//

import Foundation

protocol NetworkManagerProtocol: AnyObject {
    func fetchToDoItems(completion: @escaping ([APItoDoItem]) -> Void)
}

final class NetworkManager: NetworkManagerProtocol {
    let sessionConfig = URLSession(configuration: .default)
    let session = URLSession.shared
    let decoder = JSONDecoder()
    
    func fetchToDoItems(completion: @escaping ([APItoDoItem]) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            DispatchQueue.main.async {
                completion([])
            }
            return
        }
        session.dataTask(with: url) { [weak self] (data, response, error) in
            guard let strongSelf = self else {
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            if error == nil, let data = data {
                guard let recievedToDoItems = try? strongSelf.decoder.decode(APIresponse.self, from: data) else {
                    DispatchQueue.main.async {
                        completion([])
                    }
                    return }
                DispatchQueue.main.async {
                    completion(recievedToDoItems.todos)
                }
            } else {
                guard let error = error else { return }
                DispatchQueue.main.async {
                    completion([])
                }
                print("Error: \(error.localizedDescription)")
                
            }
        }.resume()
    }
}
