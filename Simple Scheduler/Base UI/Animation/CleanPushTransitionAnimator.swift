//
//  CleanPushTransitionAnimator.swift
//  Simple Scheduler
//
//  Created by Alan Li on 2018-10-06.
//  Copyright © 2018 Alan Li. All rights reserved.
//

import UIKit

class CleanPushTransitionAnimator: NSObject {
    
    private struct Constants {
        static let animationDuration: TimeInterval = 0.3
    }
}

extension CleanPushTransitionAnimator: UIViewControllerAnimatedTransitioning {
   
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Constants.animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard
            let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from) else {
                assertionFailure("to, from view controllers not present in context")
                transitionContext.completeTransition(false)
                return
        }
        transitionContext.containerView.addSubview(toViewController.view)
        toViewController.view.alpha = 0
        
        UIView.animate(withDuration: Constants.animationDuration) {
        }
        
        UIView.animate(
            withDuration: Constants.animationDuration,
            animations: {
                fromViewController.view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                toViewController.view.alpha = 1
        }, completion: { _ in
            fromViewController.view.transform = .identity
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

extension CleanPushTransitionAnimator: UIViewControllerInteractiveTransitioning {
    
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        
    }
}
