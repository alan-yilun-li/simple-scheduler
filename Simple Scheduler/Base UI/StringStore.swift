//
//  StringStore.swift
//  Simple Scheduler
//
//  Created by Alan Li on 2018-10-06.
//  Copyright © 2018 Alan Li. All rights reserved.
//

import Foundation

struct StringStore {
    
    // Friendly Tips
    static let friendlyTips = [
        NSLocalizedString("Call your mom? She probably misses you. ☎️", comment: "call parents"),
        NSLocalizedString("Trim your fingernails? ✌️", comment: "trim fingernails"),
        NSLocalizedString("How about some meditation? 🌱", comment: "meditate"),
        NSLocalizedString("Have you had your 8 cups? Drink some water? 💧", comment: "drink water"),
        NSLocalizedString("Got time for some quick exercise? 💪", comment: "get exercise")
    ]

    // Login Page
    static let simple = NSLocalizedString("Simple", comment: "simple")
    static let scheduler = NSLocalizedString("Scheduler", comment: "scheduler")
    
    // Landing Page
    static let hello = NSLocalizedString("Hello!", comment: "hello")
    static let enterTask = NSLocalizedString("Enter Task", comment: "enter task")
    static let getTask = NSLocalizedString("Get Task" , comment: "get task")
    static let taskStoreDescriptionPart1 = NSLocalizedString("You've got", comment: "part1 task decsription")
    static let taskStoreDescriptionPart2 = NSLocalizedString("tasks planned", comment: "part2 task description")
//    static let noMoreTasksDescription = NSLocalizedString("You're all done for today! 😊 \n Add a task for another time?", comment: ")
    
}
