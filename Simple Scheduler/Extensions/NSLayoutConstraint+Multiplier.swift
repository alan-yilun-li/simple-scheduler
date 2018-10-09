//
//  NSLayoutConstraint+Multiplier.swift
//  Simple Scheduler
//
//  Created by Alan Li on 2018-10-07.
//  Copyright © 2018 Alan Li. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    
    func withMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}
