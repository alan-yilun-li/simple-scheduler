//
//  UserDefaults+KeyExtension.swift
//  Simple Scheduler
//
//  Created by Alan Li on 2018-10-06.
//  Copyright © 2018 Alan Li. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    private struct Keys {
        static let userDidOpenKey = "com.ayl-tasks.userDidOpen"
        static let selectedTheme = "com.ayl-tasks.selectedTheme"
        static let numberOfTasksCompleted = "com.ayl-tasks.numberOfTasksCompleted"
    }
    
    var selectedTheme: AYLTheme {
        get { return AYLTheme(rawValue: self.integer(forKey: Keys.selectedTheme))! }
        set { self.set(newValue.rawValue, forKey: Keys.selectedTheme) }
    }
    
    var numberOfTasksCompleted: Int {
        get { return self.integer(forKey: Keys.numberOfTasksCompleted) }
        set { self.set(newValue, forKey: Keys.numberOfTasksCompleted) }
    }
    
    
    var userShouldOnboard: Bool {
        // Negating to take advantage of how bool(forKey:) returns false if key not present
        get { return !self.bool(forKey: Keys.userDidOpenKey) }
        set { self.set(!newValue, forKey: Keys.userDidOpenKey) }
    }
}
