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
    
    var currentContentVC: UIViewController?
    
    private let dependencies: AYLDependencies
    private var theme: AYLTheme {
        return dependencies.theme
    }
    
    init(_ dependencies: AYLDependencies) {
        self.dependencies = dependencies
    }
    
    var sketchPadVC: SketchPadViewController!
    
    func updateStoreDescription(_ tasksPlanned: Int, _ tasksCompleted: Int) {
        viewController?.taskStoreLabel.text = "\(StringStore.taskStoreDescriptionPart1) \(tasksPlanned) \(StringStore.taskStoreDescriptionPart2), \(tasksCompleted) completed."
    }
    
    func updateFriendlyTipButton() {
        viewController?.friendlyTipButton.setTitle( StringStore.friendlyTips.randomElement(), for: .normal)
    }
}

// MARK: - Actions
extension LandingPresenter {
    
    @objc func didPressEnterTask(_ sender: UIButton) {
        if let currentContentVC = currentContentVC {
            guard type(of: currentContentVC) != EnterTaskViewController.self else {
                return
            }
            removeContentController(currentContentVC)
        }
        let contentVC = EnterTaskViewController(dependencies: dependencies)
        addContentController(contentVC)
    }
    
    @objc func didPressSettings(_ sender: UIButton) {
        
    }
    
    @objc func didPressGetTask(_ sender: UIButton) {
        sender.shake()
    }
    
    @objc func didPressFriendlyTip(_ sender: UIButton) {
        
    }
    
    @objc func keyboardWillChange(_ notif: Notification) {
        guard
            let userInfo = notif.userInfo,
            let landingVC = viewController,
            let keyboardScreenEndFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                return
        }
        if notif.name == UIResponder.keyboardWillHideNotification {
            landingVC.scrollViewBottomConstraint.constant = 0
        } else {
            landingVC.scrollViewBottomConstraint.constant = -keyboardScreenEndFrame.height
        }
        UIView.animate(withDuration: 0.5) {
            landingVC.view.layoutIfNeeded()
        }
    }
}

// MARK: - View Changing Methods
extension LandingPresenter: UIViewControllerTransitioningDelegate {
    
    func addSketchPadVC() {
        guard let vc = viewController else { return }
        sketchPadVC = SketchPadViewController(dependencies: dependencies)
        vc.addChild(sketchPadVC)
        sketchPadVC.didMove(toParent: vc)
    }
    
    func addContentController(_ child: UIViewController) {
        guard let vc = viewController else { return }
        vc.addChild(child)
        vc.embedViewInCenter(child.view)
        child.didMove(toParent: vc)
        currentContentVC = child
    }
    
    func removeContentController(_ child: UIViewController) {
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
        currentContentVC = nil
    }

}
