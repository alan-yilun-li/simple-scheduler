
import UIKit
//
///// Showing a modal that doesn't cover the screen, dimming the background.
//class PopupPresentationController: UIPresentationController {
//
//    private struct Constants {
//        static let minimumBottomPadding: CGFloat = 30
//        static let adjustmentAnimationTime: TimeInterval = 0.5
//        static let height: CGFloat = 300
//    }
//
//    var modalInsets = UIEdgeInsets(top: 30, left: 30, bottom: -1, right: 30) {
//        didSet {
//            self.containerView?.setNeedsLayout()
//        }
//    }
//
//    private var layoutView: UIView!
//
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//        self.containerView?.layoutSubviews()
//    }
//
//    override var frameOfPresentedViewInContainerView: CGRect {
//        let superFrame = containerView?.frame ?? .zero
//         CGRect(x: superFrame.minX + modalInsets.left,
//                      y: superFrame.minY + modalInsets.top,
//                      width: superFrame.width - modalInsets.left - modalInsets.right,
//                      height: Constants.height)
//    }
////
////    override init(presentedViewController: UIViewController, presenting: UIViewController!) {
////        super.init(presentedViewController: presentedViewController, presenting: presenting)
////        NotificationCenter.default.addObserver(self,
////                                               selector: #selector(keyboardWillChangeFrame),
////                                               name: UIResponder.keyboardWillChangeFrameNotification,
////                                               object: nil)
////    }
//
//    override func presentationTransitionWillBegin() {
//        layoutView = UIView()
//        layoutView.frame = containerView?.frame ?? .zero
//        layoutView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(outsideViewTapped)))
//        containerView?.addSubview(layoutView)
//    }
//
//    override func dismissalTransitionWillBegin() {
//        layoutView.removeFromSuperview()
//    }
//
//    override func containerViewWillLayoutSubviews() {
//        UIView.animate(withDuration: Constants.adjustmentAnimationTime) {
//            self.presentedView?.frame = self.frameOfPresentedViewInContainerView
//            self.layoutView.frame = self.containerView?.frame ?? .zero
//        }
//    }
////
////    @objc func keyboardWillChangeFrame(_ notif: Notification) {
////        guard let keyboardFrame = notif.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
////            return
////        }
////        modalInsets.bottom = keyboardFrame.height + Constants.minimumBottomPadding
////    }
//
//    @objc func outsideViewTapped(_ sender: UITapGestureRecognizer) {
//        presentedViewController.dismiss(animated: true, completion: nil)
//    }
//}
