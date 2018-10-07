//
//  BlankNavigationController.swift
//  Simple Scheduler
//
//  Created by Alan Li on 2018-10-07.
//  Copyright © 2018 Alan Li. All rights reserved.
//

import UIKit

/// Navigation controller, hides its bar and implements some default navigation methods.
class BlankNavigationController: UINavigationController {
    
    enum NavigationMode {
        case blankPush
    }
    
    var navigationMode: NavigationMode = .blankPush
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarHidden(true, animated: false)
        delegate = self
    }
}

// MARK: - UINavigationControllerDelegate
extension BlankNavigationController: UINavigationControllerDelegate {

    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationControllerOperation,
        from fromVC: UIViewController, to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            switch navigationMode {
            case .blankPush:
                return CleanPushTransitionAnimator()
            }
        } else {
            return nil
        }
    }
}

