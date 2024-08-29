//
//  ToDoItemEntity+CoreDataProperties.swift
//  ToDoList
//
//  Created by Kamil Biktineyev on 28.08.2024.
//
//

import Foundation
import CoreData


extension ToDoItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoItemEntity> {
        return NSFetchRequest<ToDoItemEntity>(entityName: "ToDoItemEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var dateOfCreationString: String
    @NSManaged public var isCompleted: Bool
    @NSManaged public var dateOfCreation: Date

}

extension ToDoItemEntity : Identifiable {

}
