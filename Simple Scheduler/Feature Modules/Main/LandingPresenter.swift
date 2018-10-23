//
//  LandingPresenter.swift
//  Simple Scheduler
//
//  Created by Alan Li on 2018-10-07.
//  Copyright © 2018 Alan Li. All rights reserved.
//

import UIKit
import CoreData

class LandingPresenter: NSObject {
    
    weak var viewController: LandingViewController?
    var currentContentVC: UIViewController?

    private let dependencies: AYLDependencies
    private var theme: AYLTheme {
        return dependencies.theme
    }
    
    private lazy var taskFetchRequest: NSFetchRequest<Task> = {
        let request = Task.sortedFetchRequest
        request.fetchBatchSize = 10
        request.returnsObjectsAsFaults = true
        return request
    }()
    
    private var tasks = [Task]()
    
    var sketchPadVC: SketchPadViewController!
    var storeDescription: String! {
        didSet {
            viewController?.taskStoreLabel.text = storeDescription
        }
    }
    
    init(_ dependencies: AYLDependencies) {
        self.dependencies = dependencies
        super.init()
        setupCoreDataListening()
    }
    
    func updateFriendlyTipButton() {
        viewController?.friendlyTipButton.setTitle( StringStore.friendlyTips.randomElement(), for: .normal)
    }
    
    private func updateStoreDescription(_ tasksPlanned: Int, _ tasksCompleted: Int) {
        storeDescription = "\(StringStore.taskStoreDescriptionPart1) \(tasksPlanned) \(StringStore.taskStoreDescriptionPart2), \(tasksCompleted) completed."
    }
}

// MARK: - Actions
extension LandingPresenter {
    
    @objc func didPressEnterTask(_ sender: UIButton) {
       assertionFailure("wat")
    }
    
    @objc func didPressSettings(_ sender: UIButton) {
        
    }
    
    @objc func didPressGetTask(_ sender: UIButton) {
        sender.shake()
    }
    
    @objc func didPressFriendlyTip(_ sender: UIButton) {
        
    }
    
    @objc func didPressScreen(_ sender: UITapGestureRecognizer) {
        sketchPadVC.view.endEditing(true)
    }
    
    @objc func keyboardWillChange(_ notif: Notification) {
        guard
            let userInfo = notif.userInfo,
            let landingVC = viewController,
            let keyboardScreenEndFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                return
        }
        guard !sketchPadVC.isSketching else {
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

// MARK: - Enter Task Delegate
extension LandingPresenter: EnterTaskDelegate {
    
    func enterNamePressed() {
        sketchPadVC.textView.resignFirstResponder()
        viewController?.hideSketchPadView()
    }
    
    func enterNameDoneEditing() {
        viewController?.showSketchPadView()
    }
    
    func pressedEnterTime() {
        
    }
    
    func enterTimeDoneEditing() {
    }
    
    func pressedEnterDifficulty() {
        
    }

}

// MARK: - View Changing Methods
extension LandingPresenter: UIViewControllerTransitioningDelegate {
    
    func addSketchPadVC() {
        guard let vc = viewController else { return }
        sketchPadVC = SketchPadViewController(dependencies: dependencies)
        vc.addChild(sketchPadVC)
        vc.setupSketchPadView()
        sketchPadVC.didMove(toParent: vc)
    }
    
    func addContentController(_ child: UIViewController) {
        guard let vc = viewController else { return }
        
        if let enterTaskVC = child as? EnterTaskViewController {
            enterTaskVC.delegate = self
        }
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

// MARK: - Core Data Support
extension LandingPresenter: NSFetchedResultsControllerDelegate {
    
    func setupCoreDataListening() {
        let context = dependencies.persistentContainer.viewContext
        do {
            tasks = try context.fetch(taskFetchRequest)
            let numTasksCompleted = dependencies.defaults.numberOfTasksCompleted
            updateStoreDescription(tasks.count, numTasksCompleted)
        } catch {
            assertionFailure("perform fetch failed test")
        }
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange), name: .NSManagedObjectContextObjectsDidChange, object: context)
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextWillSave), name: .NSManagedObjectContextWillSave, object: context)
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextDidSave), name: .NSManagedObjectContextDidSave, object: context)
    }
    
    @objc func managedObjectContextObjectsDidChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>, inserts.count > 0 {
            for task in inserts where task is Task{
                tasks.append(task as! Task)
            }
        }
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>, deletes.count > 0 {
            var i = 0
            while i < tasks.count {
                if deletes.contains(tasks[i]) {
                    tasks.remove(at: i)
                    continue
                }
                i += 1
            }
        }
        updateStoreDescription(tasks.count, dependencies.defaults.numberOfTasksCompleted)
    }
    
    @objc func managedObjectContextWillSave(_ notification: Notification) {
        print("test")
    }
    
    @objc func managedObjectContextDidSave(_ notification: Notification) {
        print("TesttesT")
    }
}
