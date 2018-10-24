//
//  TaskActionDelegate.swift
//  Simple Scheduler
//
//  Created by Alan Li on 2018-10-23.
//  Copyright © 2018 Alan Li. All rights reserved.
//

import Foundation

protocol TaskActionDelegate: class {
    func enterNamePressed()
    func enterNameDoneEditing()
    func enterTimePressed()
    func enterTimeDoneEditing()
    func enterDifficultyPressed()
    func enterDifficultyDoneEditing()
    
    func taskActionButtonPressed()
}

extension TaskActionDelegate {
    func enterNamePressed() {}
    func enterNameDoneEditing() {}
    
    func enterTimePressed() {}
    func enterTimeDoneEditing() {}
    
    func enterDifficultyPressed() {}
    func enterDifficultyDoneEditing() {}
}
