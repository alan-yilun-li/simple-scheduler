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
        static let animationDuration: TimeInterval = 0.35
    }
}

extension CleanPushTransitionAnimator: UIViewControllerAnimatedTransitioning {
   
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Constants.animationDuration
    }
   
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to) else { return }
        
        let width = fromView.frame.width
        let height = fromView.frame.height
        let centerFrame = CGRect(x: 0, y: 0, width: width, height: height)
        let leftFrame = CGRect(x: -width, y: 0, width: width, height: height)
        let rightFrame = CGRect(x: width, y: 0, width: width, height: height)
        
        transitionContext.containerView.addSubview(toView)
        toView.frame = rightFrame
        
        toView.layoutIfNeeded()
        
        UIView.animate(
            withDuration: Constants.animationDuration,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                fromView.frame = leftFrame
                toView.frame = centerFrame
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
