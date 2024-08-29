//
//  ToDoListTests.swift
//  ToDoListTests
//
//  Created by Kamil Biktineyev on 23.08.2024.
//

import XCTest
@testable import ToDoList

final class ToDoListTests: XCTestCase {
    
    var interactor: ToDoListInteractorProtocol!
    var networkManager: NetworkManagerProtocol!
    var coreDataManager: CoreDataManagerProtocol!
    
    let testToDoItems: [ToDoItem] = [
        ToDoItem(title: "Go to the gym"),
        ToDoItem(title: "Buy a coke"),
        ToDoItem(title: "Try something new")
    ]
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        networkManager = NetworkManagerMock()
        coreDataManager = CoreDataManagerMock()
        interactor = ToDoListInteractor(networkManager: networkManager, coreDataManager: coreDataManager)
    }

    override func tearDownWithError() throws {
        networkManager = nil
        coreDataManager = nil
        interactor = nil
        try super.tearDownWithError()
    }

    func testCountItemsInToDoList() {
        interactor.toDoItems = testToDoItems
        let result = interactor.countItemsInToDoList()
        let expectedResult = 3
        XCTAssertEqual(result, expectedResult)
    }
    
    func testAddToDoItem() {
        let expectation = self.expectation(description: "testAddToDoItem")
        interactor.toDoItems = testToDoItems
        let toDoItemInitCount = interactor.toDoItems.count
        interactor.addToDoItem()
        DispatchQueue.global(qos: .background).async {
            while self.interactor.toDoItems.count == toDoItemInitCount {
                sleep(1)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        let result = interactor.toDoItems[0].title
        let expectedResult = ""
        XCTAssertEqual(result, expectedResult)
    }
    
    func testDeleteToDoItem() {
        let expectation = self.expectation(description: "testDeleteToDoItem")
        interactor.toDoItems = testToDoItems
        let toDoItemInitCount = interactor.toDoItems.count
        interactor.deleteToDoItem(index: 0)
        DispatchQueue.global(qos: .background).async {
            while self.interactor.toDoItems.count == toDoItemInitCount {
                sleep(1)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        let result = interactor.toDoItems[0].title
        let expectedResult = "Buy a coke"
        XCTAssertEqual(result, expectedResult)
    }
    
    func testChangeStatusOfToDoItem() {
        let expectation = self.expectation(description: "testChangeStatusOfToDoItem")
        interactor.toDoItems = testToDoItems
        let initToDoItems = interactor.toDoItems
        interactor.changeStatusOfToDoItem(id: interactor.toDoItems[0].id)
        DispatchQueue.global(qos: .background).async {
            while self.interactor.toDoItems == initToDoItems {
                sleep(1)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        let result = interactor.toDoItems.contains { $0.isCompleted }
        XCTAssert(result)
    }
    
    func testSaveToDoItemChanges() {
        let expectation = self.expectation(description: "testSaveToDoItemChanges")
        interactor.toDoItems = testToDoItems
        let initToDoItems = interactor.toDoItems
        interactor.saveToDoItemChanges(id: interactor.toDoItems[0].id, title: "Go to the gym tommorow")
        DispatchQueue.global(qos: .background).async {
            while self.interactor.toDoItems == initToDoItems {
                sleep(1)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        let result = interactor.toDoItems[0].title
        let expectedResult = "Go to the gym tommorow"
        XCTAssertEqual(result, expectedResult)
    }
    
    func testFilterToDoListByCreationDate() {
        let expectation = self.expectation(description: "testFilterToDoListByCreationDate")
        interactor.toDoItems = testToDoItems
        let newToDoItem = ToDoItem(title: "Read a book")
        interactor.toDoItems.append(newToDoItem)
        let initToDoItems = interactor.toDoItems
        interactor.filterToDoListByCreationDate()
        DispatchQueue.global(qos: .background).async {
            while self.interactor.toDoItems == initToDoItems {
                sleep(1)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        let result = interactor.toDoItems[0].id
        let expectedResult = newToDoItem.id
        XCTAssertEqual(result, expectedResult)
    }
    
    func testFetchAPIToDoItems() {
        let expectation = self.expectation(description: "testFetchAPIToDoItems")
        let initToDoItems = interactor.toDoItems
        interactor.fetchAPIToDoItems()
        DispatchQueue.global(qos: .background).async {
            while self.interactor.toDoItems == initToDoItems {
                sleep(1)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        let result1 = interactor.toDoItems.contains { $0.title == "Learn calligraphy" }
        XCTAssert(result1)
        let result2 = interactor.toDoItems.count
        let expectedResult2 = 2
        XCTAssertEqual(result2, expectedResult2)
    }
}
