//
//  TaskGetViewController.swift
//  Simple Scheduler
//
//  Created by Alan Li on 2018-10-26.
//  Copyright © 2018 Alan Li. All rights reserved.
//

import UIKit

class TaskGetViewController: UIViewController {
    
    private struct Constants {
        static let defaultSpacing: CGFloat = 16.0
    }
    
    private let dependencies: AYLDependencies
    private var theme: AYLTheme {
        return dependencies.theme
    }
    
    private let task: Task
    
    init(dependencies: AYLDependencies, task: Task) {
        self.dependencies = dependencies
        self.task = task
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupViews()
        setupConstraints()
    }

}

// MARK: - View Setup
extension TaskGetViewController {
    
    func setupViews() {
        view.backgroundColor = .white
    }
    
    func setupConstraints() {
        
    }
}
