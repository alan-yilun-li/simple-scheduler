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
        return dependencies.defaults.selectedTheme
    }
    
    init(_ dependencies: AYLDependencies) {
        self.dependencies = dependencies
    }
    
    func updateStoreDescription(_ items: Int) {
        viewController?.taskStoreLabel.text = "\(StringStore.taskStoreDescriptionPart1) \(items) \(StringStore.taskStoreDescriptionPart2)"
    }
    
    func updateFriendlyTipLabel() {
        viewController?.friendlyTipLabel.text = StringStore.friendlyTips.randomElement()
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

    }
}

// MARK: - View Changing Methods
extension LandingPresenter: UIViewControllerTransitioningDelegate {
    
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
