//
//  HitTestButton.swift
//  Simple Scheduler
//
//  Created by Alan Li on 2018-10-06.
//  Copyright © 2018 Alan Li. All rights reserved.
//

import UIKit

class HitTestButton: UIButton {
    
    var hitArea: CGRect?
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if let customArea = hitArea {
            return customArea.contains(point)
        }
        return super.point(inside: point, with: event)
    }
}
