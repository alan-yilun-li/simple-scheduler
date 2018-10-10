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

    let presenting: Bool
    let fromView: UIView

    init<FromView: ViewExpansionAnimatable>(presenting: Bool, fromView: FromView) {
        self.presenting = presenting
        self.fromView = fromView
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return presenting ? Constants.presentingDuration : Constants.dismissalDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let toView = transitionContext.view(forKey: .to) else {
            return
        }
        let detailView = presenting ? toView: fromView
        let originFrame = fromView.convert(fromView.frame, to: fromView.superview)

        let initialFrame: CGRect
        let finalFrame: CGRect
        let xScaleFactor: CGFloat
        let yScaleFactor: CGFloat
        if presenting {
            initialFrame = originFrame
            finalFrame = detailView.frame
            xScaleFactor = initialFrame.width / finalFrame.width
            yScaleFactor = initialFrame.height / finalFrame.height
        } else {
            initialFrame = detailView.frame
            finalFrame = originFrame
            xScaleFactor = finalFrame.width / initialFrame.width
            yScaleFactor = finalFrame.height / initialFrame.height
        }
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor,
                                               y: yScaleFactor)
        if presenting {
            detailView.transform = scaleTransform
            detailView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
            detailView.clipsToBounds = true
        }
        containerView.addSubview(toView)
        containerView.bringSubview(toFront: detailView)

        if presenting {
            UIView.animate(
                withDuration: Constants.presentingDuration,
                delay:0.0,
                usingSpringWithDamping: 1.0,
                initialSpringVelocity: 0.0,
                animations: {
                    detailView.transform = CGAffineTransform.identity
                    detailView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            },
                completion:{_ in
                    transitionContext.completeTransition(true)
            })
        } else {
            UIView.animate(
                withDuration: Constants.dismissalDuration,
                delay:0.0,
                options: .curveEaseInOut,
                animations: {
                    detailView.transform = scaleTransform
                    detailView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            },
                completion:{ _ in
                    transitionContext.completeTransition(true)
            })
        }
    }
}
