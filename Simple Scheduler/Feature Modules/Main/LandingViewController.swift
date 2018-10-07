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
    
    lazy var friendlyTipLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = theme.fonts.smallItalicized
        label.textColor = theme.colours.mainTextColor
        label.layer.opacity = 0.8
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var taskStoreLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = theme.fonts.small
        label.textColor = theme.colours.mainTextColor
        return label
    }()
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = theme.fonts.mainTitle
        label.textColor = theme.colours.mainTextColor
        label.text = StringStore.hello
        return label
    }()

    private lazy var settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(theme.colours.mainTextColor, for: .normal)
        button.titleLabel?.font = theme.fonts.mainTitle
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(">", for: .normal)
        return button
    }()
    
    let presenter: LandingPresenter
    
    init(_ dependencies: AYLDependencies, presenter: LandingPresenter) {
        self.dependencies = dependencies
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        presenter.viewController = self
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
        view.addSubview(taskStoreLabel)
        view.addSubview(welcomeLabel)
        view.addSubview(settingsButton)
        view.addSubview(friendlyTipLabel)
        
        presenter.updateStoreDescription(0)
        presenter.updateFriendlyTipLabel()
        
        enterTaskButton.addTarget(presenter, action: #selector(presenter.didPressEnterTask), for: .touchUpInside)
        settingsButton.addTarget(presenter, action: #selector(presenter.didPressSettings), for: .touchUpInside)
        getTaskButton.addTarget(presenter, action: #selector(presenter.didPressGetTask), for: .touchUpInside)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.defaultSpacing),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.defaultSpacing),
            welcomeLabel.trailingAnchor.constraint(lessThanOrEqualTo: settingsButton.leadingAnchor, constant: -Constants.defaultSpacing),
            
            settingsButton.centerYAnchor.constraint(equalTo: welcomeLabel.centerYAnchor),
            settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.defaultSpacing),
            
            friendlyTipLabel.topAnchor.constraint(equalTo: welcomeLabel.topAnchor, constant: Constants.defaultSpacing),
            friendlyTipLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            friendlyTipLabel.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),

            taskStoreLabel.topAnchor.constraint(equalTo: friendlyTipLabel.bottomAnchor, constant: Constants.defaultSpacing),
            taskStoreLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            taskStoreLabel.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            taskStoreLabel.bottomAnchor.constraint(lessThanOrEqualTo: enterTaskButton.topAnchor, constant: -Constants.defaultSpacing),

            enterTaskButton.topAnchor.constraint(greaterThanOrEqualTo: welcomeLabel.bottomAnchor),
            enterTaskButton.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            enterTaskButton.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),

            getTaskButton.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            getTaskButton.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            getTaskButton.topAnchor.constraint(equalTo: enterTaskButton.bottomAnchor, constant: Constants.defaultSpacing),
            getTaskButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.defaultSpacing),
            
            // explicit sizing
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
