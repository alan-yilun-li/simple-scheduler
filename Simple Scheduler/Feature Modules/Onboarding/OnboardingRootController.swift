//
//  ViewController.swift
//  Simple Scheduler
//
//  Created by Alan Li on 2018-10-06.
//  Copyright © 2018 Alan Li. All rights reserved.
//

import UIKit

class OnboardingRootController: UIViewController {
    
    private struct Constants {
        static let defaultSpacing: CGFloat = 16.0
    }
    
    private let dependencies: AYLDependencies
    private var theme: AYLTheme {
        return dependencies.defaults.selectedTheme
    }
    
    private lazy var simpleLabel = makeTitleLabel(StringStore.simple)
    private lazy var schedulerLabel = makeTitleLabel(StringStore.scheduler)
    
    init(_ dependencies: AYLDependencies) {
        self.dependencies = dependencies
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }
}

// MARK: - View Setup
private extension OnboardingRootController {
    
    func setupViews() {
        view.backgroundColor = theme.mainColor
        
        view.addSubview(simpleLabel)
        view.addSubview(schedulerLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            simpleLabel.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor),
            
            simpleLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            schedulerLabel.leadingAnchor.constraint(equalTo: simpleLabel.leadingAnchor),
    
            simpleLabel.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            schedulerLabel.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            
            schedulerLabel.topAnchor.constraint(
                equalTo: simpleLabel.bottomAnchor,
                constant: Constants.defaultSpacing / 2
            ),
            schedulerLabel.bottomAnchor.constraint(
                equalTo: view.centerYAnchor,
                constant: -Constants.defaultSpacing
            )
        ])
    }
    
    func makeTitleLabel(_ text: String) -> UILabel {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
//        label.font = theme.mainTitleFont
//        label.textColor = theme.mainTextColor
//        label.adjustsFontForContentSizeCategory = true
//
        return label
    }
}
