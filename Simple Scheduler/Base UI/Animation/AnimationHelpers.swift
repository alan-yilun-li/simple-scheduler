//
//  InteractiveAnimator.swift
//  Simple Scheduler
//
//  Created by Alan Li on 2018-10-08.
//  Copyright © 2018 Alan Li. All rights reserved.
//

import UIKit

protocol InteractiveAnimator: UIViewControllerInteractiveTransitioning {
    
    var isAnimating: Bool { get }
}

enum TransitionDirection {
    case left, right
}
