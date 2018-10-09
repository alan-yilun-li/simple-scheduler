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
    
    private var popInteractors = [InteractiveAnimator]()
    private var pushInteractors = [InteractiveAnimator]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarHidden(true, animated: false)
        delegate = self
    }
    
    func setupTopController(forPushing toVC: UIViewController) {
        guard let topController = topViewController else { return }
        let interactor = CleanPushPopInteractor(
            for: topController,
            direction: .right,
            { [weak self] in self?.pushViewController(toVC, animated: true) },
            completion: { [weak self] in self?.pushInteractors.removeFirst() }
        )
        pushInteractors.append(interactor)
    }
}

// MARK: - UINavigationControllerDelegate
extension BlankNavigationController: UINavigationControllerDelegate {
    
    func navigationController(
        _ navigationController: UINavigationController,
        interactionControllerFor animationController: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        
        if navigationMode == .blankPush {
            guard let animator = animationController as? CleanPushTransitionAnimator else {
                assertionFailure("Incorrect class found")
                return nil
            }
            let interactor: InteractiveAnimator?
            switch animator.direction {
            case .left:
                interactor = popInteractors.last
            case .right:
                interactor = pushInteractors.first
            }
            guard let interactiveAnimator = interactor else {
                assertionFailure("Did not properly configure interactors")
                return nil
            }
            return interactiveAnimator.isAnimating ? interactiveAnimator : nil
        }
        return nil
    }

    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationControllerOperation,
        from fromVC: UIViewController, to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            switch navigationMode {
            case .blankPush:
                let interactor = CleanPushPopInteractor(
                    for: toVC,
                    direction: .left,
                    { [weak self] in self?.popViewController(animated: true) },
                    completion: { [weak self] in self?.popInteractors.removeLast() }
                )
                popInteractors.append(interactor)
                return CleanPushTransitionAnimator(direction: .right)
            }
        } else {
            return CleanPushTransitionAnimator(direction: .left)
        }
    }
}

