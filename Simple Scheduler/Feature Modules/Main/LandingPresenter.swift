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
    
    func updateStoreDescription(_ items: Int) {
        viewController?.taskStoreLabel.text = "\(StringStore.taskStoreDescriptionPart1) \(items) \(StringStore.taskStoreDescriptionPart2)"
    }
    
    func updateFriendlyTipLabel() {
        viewController?.friendlyTipLabel.text =
        
    }
}

// MARK: - Actions
extension LandingPresenter {
    
    @objc func didPressEnterTask() {
        viewController?.navigationController?.pushViewController(TestViewController(), animated: true)
    }
    
    @objc func didPressSettings() {
        
    }
    
    @objc func didPressGetTask() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
