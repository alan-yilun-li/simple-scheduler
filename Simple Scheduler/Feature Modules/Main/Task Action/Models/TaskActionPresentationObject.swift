//
//  TaskActionPresentationObject.swift
//  Simple Scheduler
//
//  Created by Alan Li on 10/24/18.
//  Copyright © 2018 Alan Li. All rights reserved.
//

import Foundation

protocol PresentationObjectDelegate {
    func modeDidChange(_ presentationObject: TaskActionPresentationObject)
}

struct TaskActionPresentationObject {

    enum Mode {
        case enter, get
    }

    var mode: Mode {
        didSet {
            delegate?.modeDidChange(self)
        }
    }
    var delegate: PresentationObjectDelegate?

    var editTimeText: String {
        switch mode {
        case .enter: return "⌛ Expected Time"
        case .get: return "⌛ Available Time"
        }
    }

    var titleText: String {
        switch mode {
        case .enter: return  "📬 \(StringStore.enterTask)"
        case .get: return  "🔨 \(StringStore.getTask)"
        }
    }

    var actionText: String {
        switch mode {
        case .enter: return StringStore.enterTask
        case .get: return StringStore.getTask
        }
    }
}
