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
    lazy var taskActionViewController: TaskActionViewController = {
        let controller = TaskActionViewController(dependencies: dependencies)
        controller.delegate = self
        return controller
    }()

    private let dependencies: AYLDependencies
    private var theme: AYLTheme {
        return dependencies.theme
    }

    var currentFriendlyTip: FriendlyTip!
    
    private lazy var taskFetchRequest: NSFetchRequest<Task> = {
        let request = Task.sortedFetchRequest
        // Only need to fulfill one at a time
        request.returnsObjectsAsFaults = true
        return request
    }()
    
    private var tasks = [Task]() {
        // Forwarding to task action controller, also forwards mutations since Array is a value-type
        didSet {
            taskActionViewController.tasks = tasks
        }
    }
    
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
        var newTip = FriendlyTip.Defaults.array.randomElement()!
        if let currentTip = currentFriendlyTip {
            while (newTip.taskName == currentTip.taskName) {
                newTip = FriendlyTip.Defaults.array.randomElement()!
            }
        }
        currentFriendlyTip = newTip
        viewController?.friendlyTipButton.setTitle(currentFriendlyTip.motivationText, for: .normal)
    }
    
    private func updateStoreDescription(_ tasksPlanned: Int, _ tasksCompleted: Int) {
        storeDescription = "\(StringStore.taskStoreDescriptionPart1) \(tasksPlanned) \(StringStore.taskStoreDescriptionPart2), \(tasksCompleted) completed."
    }
}

// MARK: - Actions
extension LandingPresenter {
    
    @objc func didPressSettings(_ sender: UIButton) {
        
    }
    
    @objc func didPressTaskAction(_ sender: UIButton) {
        taskActionViewController.mode == .enter ? switchToGetMode() : switchToEnterMode()
    }
    
    @objc func didPressFriendlyTip(_ sender: UIButton) {
        switchToEnterMode()
        taskActionViewController.setName(currentFriendlyTip.taskName)
        taskActionViewController.setTime(currentFriendlyTip.taskTime / 60, minutes: currentFriendlyTip.taskTime % 60)
        updateFriendlyTipButton()
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
extension LandingPresenter: TaskActionDelegate {
    
    func enterNamePressed() {
        sketchPadVC.textView.resignFirstResponder()
        viewController?.hideSketchPadView()
    }
    
    func enterNameDoneEditing() {
        viewController?.showSketchPadView()
    }
    
    func taskActionButtonPressed() {
        
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

// MARK: - Private Helpers
private extension LandingPresenter {

    func switchToGetMode() {
        taskActionViewController.mode = .get
        viewController?.taskActionButton.setTitle(StringStore.enterTask, for: .normal)
    }

    func switchToEnterMode() {
        taskActionViewController.mode = .enter
        viewController?.taskActionButton.setTitle(StringStore.getTask, for: .normal)
    }
}
