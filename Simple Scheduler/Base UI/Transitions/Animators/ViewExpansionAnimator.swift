//
//  ViewExpansionAnimator.swift
//  
//
//  Created by Alan Li on 10/9/18.
//

import UIKit

protocol ViewExpansionAnimatable: NSCopying where Self: UIView {}

class ViewExpansionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    private struct Constants {
        static let presentingDuration: TimeInterval = 0.5
        static let dismissalDuration: TimeInterval = 0.5
    }

    let isPresenting: Bool
    private let copyFromView: UIView

    init<FromView: ViewExpansionAnimatable>(isPresenting: Bool, fromView: FromView) {
        self.isPresenting = isPresenting

        guard let copyView = fromView.copy() as? UIView else {
            assertionFailure("Protocol mandates something should be uiview but it's not")
            self.copyFromView = fromView
            return
        }
        self.copyFromView = copyView
        copyFromView.frame = fromView.frame
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return isPresenting ? Constants.presentingDuration : Constants.dismissalDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toVC = transitionContext.viewController(forKey: .to)
        let toView = transitionContext.view(forKey: .to)
        let fromVC = transitionContext.viewController(forKey: .from)
        let fromView = transitionContext.view(forKey: .from)
        
        let containerFrame = containerView.frame
        var toViewStartFrame = transitionContext.initialFrame(for: toVC!)
        let toViewFinalFrame = transitionContext.finalFrame(for: toVC!)
        var fromViewFinalFrame = transitionContext.finalFrame(for: fromVC!)
        
        if isPresenting {
            toViewStartFrame.origin.x = containerFrame.size.width
            toViewStartFrame.origin.y = containerFrame.size.height
        }
            else {
            fromViewFinalFrame = CGRect(x: containerFrame.size.width,
                                        y:     containerFrame.size.height,
                                        width:      toVC!.view!.frame.size.width,
                                        height:      toVC!.view!.frame.size.height)
            }
        
//            containerView.addSubview(toView!)
            toView!.frame = toViewStartFrame
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       animations: {
                        
                        if self.isPresenting {
                            toView?.frame = toViewFinalFrame
                        } else {
                            fromView?.frame = fromViewFinalFrame
                        }
        }) { finished in
            let success = !transitionContext.transitionWasCancelled
            if (self.isPresenting && !success) || (!self.isPresenting && success) {
                toView?.removeFromSuperview()
            }
            transitionContext.completeTransition(success)
        }
        
//        let containerView = transitionContext.containerView
//        guard let toView = transitionContext.view(forKey: .to) else {
//            return
//        }
//        guard let fromView = transitionContext.view(forKey: .from) else {
//            return
//        }
//
//        if !isPresenting {
//            containerView.addSubview(fromView)
//            containerView.bringSubview(toFront: fromView)
//            fromView.backgroundColor = .purple
//        }
//
//        containerView.addSubview(copyFromView)
//        containerView.bringSubview(toFront: copyFromView)
//        let initialFrame = copyFromView.frame
//        let finalFrame = toView.frame
//
//        if isPresenting {
//            toView.frame = initialFrame
//            containerView.addSubview(toView)
//        } else {
//            copyFromView.frame = finalFrame
//        }
//
//        containerView.layoutIfNeeded()
//
//        UIView.animate(
//            withDuration: isPresenting ? Constants.presentingDuration : Constants.dismissalDuration,
//            delay:0.0,
//            usingSpringWithDamping: 1.0,
//            initialSpringVelocity: 0.0,
//            animations: {
//                if self.isPresenting {
//                    toView.frame = finalFrame
//                    self.copyFromView.frame = finalFrame
//                } else {
//                    toView.frame = initialFrame
//                    self.copyFromView.frame = initialFrame
//                }
//        },
//            completion:{_ in
//                self.copyFromView.removeFromSuperview()
//                transitionContext.completeTransition(true)
//        })
    }
}
