//
//  EditTaskModel.swift
//  Simple Scheduler
//
//  Created by Alan Li on 10/24/18.
//  Copyright © 2018 Alan Li. All rights reserved.
//

import Foundation

struct EditTaskModel {

    var delegate: EditTaskModelDelegate?

    var name: String? {
        didSet {
            delegate?.editTaskModelDidChange(self)
        }
    }
    var time: Int? {
        didSet {
            delegate?.editTaskModelDidChange(self)
        }
    }

    init(name: String? = nil, time: Int? = nil, delegate: EditTaskModelDelegate? = nil) {
        self.name = name
        self.time = time
        self.delegate = delegate
    }

    func isFilled(_ enterTaskMode: Bool) -> Bool {
        if enterTaskMode {
            return time != nil && (name != nil && name != "")
        } else {
            return time != nil
        }
    }
}

protocol EditTaskModelDelegate {
    func editTaskModelDidChange(_ editTaskModel: EditTaskModel)
}
