//
//  LandingViewController.swift
//  Simple Scheduler
//
//  Created by Alan Li on 2018-10-07.
//  Copyright © 2018 Alan Li. All rights reserved.
//

import Foundation
//
//  ViewController.swift
//  Simple Scheduler
//
//  Created by Alan Li on 2018-10-06.
//  Copyright © 2018 Alan Li. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {
    
    private struct Constants {
        static let defaultSpacing: CGFloat = 16.0
        static let buttonSpacing: CGFloat = 25.0
        
        static let buttonBorderWidth: CGFloat = 3.0
        static let buttonLineHeightPercentage: CGFloat = 2.0
        static let buttonWidthProportion: CGFloat = 0.75
    }
    
    private let dependencies: AYLDependencies
    private var theme: AYLTheme {
        return dependencies.defaults.selectedTheme
    }
    
    private lazy var enterTaskButton = makeButton(StringStore.enterTask)
    private lazy var getTaskButton = makeButton(StringStore.getTask)
    private lazy var taskStoreLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = theme.fonts.
        
    }
    
    let presenter: LandingPresenter
    
    init(_ dependencies: AYLDependencies, presenter: LandingPresenter) {
        self.dependencies = dependencies
        self.presenter = presenter
        presenter.viewController = self
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

// MARK: - Actions
extension LandingViewController {

}

// MARK: - View Setup
private extension LandingViewController {
    
    func setupViews() {
        view.backgroundColor = theme.colours.mainColor
        
        theme(enterTaskButton, theme.colours.mainTextColor, backgroundColor: theme.colours.mainColor, withBorder: true)
        theme(getTaskButton, theme.colours.mainColor, backgroundColor: theme.colours.secondaryColor)
        
        view.addSubview(enterTaskButton)
        view.addSubview(getTaskButton)
        
        let button = enterTaskButton
        button.layer.borderWidth = 2
        
        
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([

            enterTaskButton.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor),
            enterTaskButton.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            enterTaskButton.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),

            getTaskButton.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            getTaskButton.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            getTaskButton.topAnchor.constraint(equalTo: enterTaskButton.bottomAnchor, constant: Constants.buttonSpacing),
            
            enterTaskButton.widthAnchor.constraint(equalTo: view.widthAnchor).withMultiplier(Constants.buttonWidthProportion),
            getTaskButton.widthAnchor.constraint(equalTo: view.widthAnchor).withMultiplier(Constants.buttonWidthProportion)
        ])
    }
    
    func theme(_ button: UIButton, _ textColor: UIColor, backgroundColor: UIColor, withBorder: Bool = false) {
        if withBorder {
            button.layer.borderColor = textColor.cgColor
        }
        button.backgroundColor = backgroundColor
        button.setTitleColor(textColor, for: .normal)
    }
    
    func makeButton(_ text: String) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = theme.fonts.standard
        guard let lineHeight = button.titleLabel?.font.lineHeight else {
            assertionFailure("titlelabel of button doesn't exist")
            return button
        }
        let buttonHeight = lineHeight * Constants.buttonLineHeightPercentage
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: buttonHeight),
        ])
        button.layer.cornerRadius = buttonHeight / 2
        button.layer.borderWidth = Constants.buttonBorderWidth

        return button
    }
}
