//
//  Task.swift
//  Simple Scheduler
//
//  Created by Alan Li on 2018-10-16.
//  Copyright © 2018 Alan Li. All rights reserved.
//

import Foundation
import CoreData

final class Task: NSManagedObject {
    
    @NSManaged fileprivate(set) var name: String
    @NSManaged fileprivate(set) var time: Int16
    @NSManaged fileprivate(set) var difficulty: Int16

    static func insert(into context: NSManagedObjectContext, name: String, time: Int16, difficulty: Int16) -> Task {
        let task: Task = context.insertObject()
        task.name = name
        task.difficulty = difficulty
        task.time = time
        return task
    }
}

extension Task: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(Task.time), ascending: false)]
    }
}
