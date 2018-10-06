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
        static let continueArrowSpacing: CGFloat = 2.0
    }
    
    private let dependencies: AYLDependencies
    private var theme: AYLTheme {
        return dependencies.defaults.selectedTheme
    }
    
    private lazy var simpleLabel = makeTitleComponent(StringStore.simple)
    private lazy var schedulerLabel = makeTitleComponent(StringStore.scheduler)
    
    private lazy var continueButton = makeContinueButtonComponent(StringStore.continue)
    private lazy var continueArrow = makeContinueButtonComponent(">")
    
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
        view.backgroundColor = theme.colours.mainColor
        
        view.addSubview(simpleLabel)
        view.addSubview(schedulerLabel)
        view.addSubview(continueButton)
        view.addSubview(continueArrow)
        
        
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            // Title Constraints
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
            ),
            
            // Continue Button Constraints
            continueButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -Constants.defaultSpacing * 2 
            ),
            continueButton.topAnchor.constraint(
                greaterThanOrEqualTo: schedulerLabel.bottomAnchor,
                constant: Constants.defaultSpacing
            ),
            
            continueArrow.centerYAnchor.constraint(equalTo: continueButton.centerYAnchor),
            continueArrow.leadingAnchor.constraint(
                equalTo: continueButton.trailingAnchor,
                constant: Constants.continueArrowSpacing
            ),
            continueArrow.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor)
        ])
    }
    
    func makeTitleComponent(_ text: String) -> UILabel {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = theme.fonts.mainTitle
        label.textColor = theme.colours.mainTextColor
        label.adjustsFontForContentSizeCategory = true
        return label
    }
    
    func makeContinueButtonComponent(_ text: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitleColor(theme.colours.mainTextColor, for: .normal)
        button.titleLabel?.font = theme.fonts.standard
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(text, for: .normal)
        return button
    }
}
