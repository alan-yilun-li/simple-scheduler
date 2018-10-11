
import UIKit

/// Showing a modal that doesn't cover the screen, dimming the background
class PopupPresentationController: UIPresentationController {

    private struct Constants {
        static let dimmingLevel: CGFloat = 0.5
    }
//    private let dimmingView = UIView()

//    var modalInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)

    override var frameOfPresentedViewInContainerView: CGRect {
        return containerView?.bounds.insetBy(dx: 30, dy: 30) ?? .zero
    }

    override init(presentedViewController: UIViewController, presenting: UIViewController!) {
        super.init(presentedViewController: presentedViewController, presenting: presenting)

//        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: Constants.dimmingLevel)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChangeFrame),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
//        dimmingView.frame = containerView?.bounds ?? .zero
//        dimmingView.alpha = 0
//        containerView?.insertSubview(dimmingView, at: 0)

        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
//            self.dimmingView.alpha = 1.0
        }, completion: nil)
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
//            self.dimmingView.alpha = 0.0
        }, completion: { _ in
//            self.dimmingView.removeFromSuperview()
        })
    }

    override func containerViewWillLayoutSubviews() {
//        dimmingView.frame = containerView?.bounds ?? .zero
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    @objc func keyboardWillChangeFrame(_ notif: Notification) {

    }
}
