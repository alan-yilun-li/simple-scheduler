
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
            guard !alertStyle else { return }
            self.containerView?.setNeedsLayout()
        }
    }
    var alertStyle: Bool = false

    private var layoutView: UIView!

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.containerView?.layoutSubviews()
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        let superFrame = containerView?.frame ?? .zero
        if alertStyle {
            let width = superFrame.width / 3
            let height = superFrame.height / 3
            return CGRect(x: ((superFrame.minX + superFrame.width) / 2) - (width / 2),
                          y: ((superFrame.minY + superFrame.height) / 2) - (height / 2),
                          width: width, height: height)
        }
        return CGRect(x: superFrame.minX + modalInsets.left,
                      y: superFrame.minY + modalInsets.top,
                      width: superFrame.width - modalInsets.left - modalInsets.right,
                      height: superFrame.height - modalInsets.top - modalInsets.bottom)

    }

    override func presentationTransitionWillBegin() {
        layoutView = UIView()
        layoutView.frame = containerView?.frame ?? .zero
        layoutView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(outsideViewTapped)))
        containerView?.addSubview(layoutView)
    }

    override func dismissalTransitionWillBegin() {
        layoutView.removeFromSuperview()
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
