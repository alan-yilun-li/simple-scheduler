//
//  CoreData+Helpers.swift
//  Simple Scheduler
//
//  Created by Alan Li on 2018-10-16.
//  Copyright © 2018 Alan Li. All rights reserved.
//

import Foundation
import CoreData


extension NSManagedObjectContext {
    func insertObject<Obj: NSManagedObject>() -> Obj where Obj: Managed {
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: Obj.entityName,
                                                            into: self) as? Obj
        else { fatalError("Wrong object type") }
        return obj
    }
    
    func saveOrRollback() -> Bool {
        do {
            try save()
            return true
        } catch {
            rollback()
            return false
        }
    }
        
    func performChanges(block: @escaping () -> ()) {
        perform {
            block()
            _ = self.saveOrRollback()
        }
    }
}

