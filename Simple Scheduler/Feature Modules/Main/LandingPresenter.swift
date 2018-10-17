//
//  LandingPresenter.swift
//  Simple Scheduler
//
//  Created by Alan Li on 2018-10-07.
//  Copyright © 2018 Alan Li. All rights reserved.
//

import UIKit

class LandingPresenter: NSObject {
    
    weak var viewController: LandingViewController?
    
    // Remembering last pressed button for the viewExpansionAnimator
    private var pressedExpandableButton: UIButton!
    
    private let dependencies: AYLDependencies
    private var theme: AYLTheme {
        return dependencies.defaults.selectedTheme
    }
    
    init(_ dependencies: AYLDependencies) {
        self.dependencies = dependencies
    }
    
    func updateStoreDescription(_ items: Int) {
        viewController?.taskStoreLabel.text = "\(StringStore.taskStoreDescriptionPart1) \(items) \(StringStore.taskStoreDescriptionPart2)"
    }
    
    func updateFriendlyTipLabel() {
        // TODO ayl: replace with random after updating to swift 4.2
        viewController?.friendlyTipLabel.text = StringStore.friendlyTips.first!
    }
}

// MARK: - Actions
extension LandingPresenter {
    
    @objc func didPressEnterTask(_ sender: UIButton) {
        pressedExpandableButton = sender
        let presentedVC = TaskActionViewController(dependencies: dependencies)
        presentedVC.transitioningDelegate = self
        presentedVC.modalPresentationStyle = .custom
        viewController?.present(presentedVC, animated: true, completion: nil)
    }
    
    @objc func didPressSettings(_ sender: UIButton) {
        
    }
    
    @objc func didPressGetTask(_ sender: UIButton) {
        pressedExpandableButton = sender
        let presentedVC = TaskActionViewController(dependencies: dependencies)
        presentedVC.transitioningDelegate = self
        presentedVC.modalPresentationStyle = .custom
        viewController?.present(presentedVC, animated: true, completion: nil)

    }
}

// MARK: - Presentation Methods
extension LandingPresenter: UIViewControllerTransitioningDelegate {
    
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        return PopupPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return nil // ViewExpansionAnimator(isPresenting: true, fromView: pressedExpandableButton)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil // ViewExpansionAnimator(isPresenting: false, fromView: pressedExpandableButton)
    }
}
