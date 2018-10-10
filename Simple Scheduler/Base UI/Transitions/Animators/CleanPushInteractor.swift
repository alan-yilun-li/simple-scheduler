//
//  CleanPushInteractiveTransitionAnimator.swift
//  Simple Scheduler
//
//  Created by Alan Li on 2018-10-07.
//  Copyright © 2018 Alan Li. All rights reserved.
//

import UIKit

class CleanPushPopInteractor: UIPercentDrivenInteractiveTransition, InteractiveAnimator {
    
    var isAnimating: Bool = false
    
    /// Percentage of the swipe at which the animation triggers
    var completionPercentage: CGFloat = 0.5
    
    /// Max velocity of swipe before animation triggers
    var maxVelocity: CGFloat = 200
    
    /// View the interaction is occuring in
    var attachedView: UIView!
    
    /// Block of the navigation action that is occuring
    let navigationBlock: (() -> Void)
    
    /// Cleanup when animation finishes
    let completion: (() -> Void)?
    
    /// Direction of the interaction
    let direction: TransitionDirection
    
    init(
        for controller: UIViewController,
        direction: TransitionDirection,
        _ navigationBlock: @escaping (() -> Void),
        completion: (() -> Void)? = nil
    ) {
        self.navigationBlock = navigationBlock
        self.completion = completion
        self.direction = direction
        super.init()
        let swipeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        swipeGesture.edges = direction == .left ? .left : .right
        attachedView = controller.view
        attachedView.addGestureRecognizer(swipeGesture)
    }
    
    @objc private func handleGesture(_ gesture: UIScreenEdgePanGestureRecognizer) {
        let viewTranslation = gesture.translation(in: gesture.view?.superview)
        let transitionProgress = viewTranslation.x / attachedView.frame.width * (direction == .right ? -1 : 1)

        switch gesture.state {
        case .began:
            isAnimating = true
            navigationBlock()
        case .changed:
            update(transitionProgress)
        case .cancelled:
            isAnimating = false
            cancel()
        case .ended:
            guard gesture.velocity(in: gesture.view).x <= maxVelocity else {
                finish()
                return
            }
            isAnimating = false
            transitionProgress > completionPercentage ? finish() : cancel()
        default:
            return
        }
    }
}
