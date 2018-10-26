
import UIKit

/// Showing a modal that doesn't cover the screen, dimming the background.
class PopupPresentationController: UIPresentationController {

    private struct Constants {
        static let minimumBottomPadding: CGFloat = 30
        static let adjustmentAnimationTime: TimeInterval = 0.5
        static let height: CGFloat = 300
    }

    var modalInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30) {
        didSet {
            guard !isAlertStyle else { return }
            self.containerView?.setNeedsLayout()
        }
    }
    var isAlertStyle: Bool = false
    var shouldDismissOutside: Bool = true

    private var layoutView: UIView!

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.containerView?.layoutSubviews()
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        let superFrame = containerView?.frame ?? .zero
        if isAlertStyle {
            let sideLength = superFrame.width * 2/3
            return CGRect(x: ((superFrame.minX + superFrame.width) / 2) - (sideLength / 2),
                          y: ((superFrame.minY + superFrame.height) / 2) - (sideLength / 2),
                          width: sideLength, height: sideLength)
        }
        return CGRect(x: superFrame.minX + modalInsets.left,
                      y: superFrame.minY + modalInsets.top,
                      width: superFrame.width - modalInsets.left - modalInsets.right,
                      height: superFrame.height - modalInsets.top - modalInsets.bottom)

    }

    override func presentationTransitionWillBegin() {
        layoutView = UIView()
        layoutView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        layoutView.frame = containerView?.frame ?? .zero
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: {
            context in
            self.layoutView.alpha = 1.0
        }, completion: nil)
        
        if shouldDismissOutside {
            layoutView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(outsideViewTapped)))
        }
        containerView?.addSubview(layoutView)
    }

    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: {
            context in
            self.layoutView.alpha = 0.0
        }, completion: {
            context in
            self.layoutView.removeFromSuperview()
        })
    }

    override func containerViewWillLayoutSubviews() {
        UIView.animate(withDuration: Constants.adjustmentAnimationTime) {
            self.presentedView?.frame = self.frameOfPresentedViewInContainerView
            self.layoutView.frame = self.containerView?.frame ?? .zero
        }
    }

    @objc func outsideViewTapped(_ sender: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
