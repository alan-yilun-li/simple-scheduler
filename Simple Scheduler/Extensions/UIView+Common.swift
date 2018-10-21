//
//  UIView+Common.swift
//  Simple Scheduler
//
//  Created by Alan Li on 2018-10-21.
//  Copyright © 2018 Alan Li. All rights reserved.
//

import UIKit

extension UIView {
    func shake(withFlash: Bool = false) {
        let keyTimes = [0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1] as [NSNumber]
        let duration = 0.4

        
        let shakeAnimation = CAKeyframeAnimation()
        shakeAnimation.keyPath = "position.x"
        shakeAnimation.values = [0, 10, -10, 10, -5, 5, -5, 0 ]
        shakeAnimation.keyTimes = keyTimes
        shakeAnimation.duration = duration
        shakeAnimation.isAdditive = true
//
//        let flashAnimation = CAKeyframeAnimation()
//        flashAnimation.keyPath = "layer.opacity"
//        flashAnimation.values = [1, 0.9, 0.8, 0.7, 0.7, 0.8, 0.9,1]
//        flashAnimation.keyTimes = keyTimes
//        flashAnimation.duration = duration
//        flashAnimation.isAdditive = true
//
        self.layer.add(shakeAnimation, forKey: "shake")
//        self.layer.add(flashAnimation, forKey: "flash")
    }
}
