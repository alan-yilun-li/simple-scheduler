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
    
    @NSManaged fileprivate(set) var timeExpected: Int
    @NSManaged fileprivate(set) var difficulty: Int

    static func insert(into context: NSManagedObjectContext, time: Int, difficulty: Int) -> Task {
        let task: Task = context.insertObject()
        task.difficulty = difficulty
        task.timeExpected = time
        return task
    }
}

extension Task: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(Task.timeExpected), ascending: false)]
    }
}
