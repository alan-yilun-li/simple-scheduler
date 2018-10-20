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
        static let friendlyTipOpacity: Float = 0.8
    }
    
    private let dependencies: AYLDependencies
    private var theme: AYLTheme {
        return dependencies.defaults.selectedTheme
    }
    
    private lazy var getTaskButton = makeButton(StringStore.getTask)
    
    lazy var friendlyTipButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(nil, for: .normal)
        button.titleLabel!.font = theme.fonts.smallItalicized
        button.setTitleColor(theme.colours.mainTextColor, for: .normal)
        button.layer.opacity = Constants.friendlyTipOpacity
        button.setTitleShadowColor(theme.colours.mainTextColor.withAlphaComponent(0.1), for: .normal)
        button.titleLabel?.shadowOffset = CGSize(width: 2, height: 2)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center

        button.addTarget(presenter, action: #selector(LandingPresenter.didPressFriendlyTip(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var taskStoreLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = theme.fonts.small
        label.textColor = theme.colours.mainTextColor
        label.numberOfLines = 0 
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
    
    func embedViewInCenter(_ viewForEmbedding: UIView) {
        view.addSubview(viewForEmbedding)
        viewForEmbedding.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            taskStoreLabel.bottomAnchor.constraint(equalTo: viewForEmbedding.topAnchor, constant: -Constants.defaultSpacing * 2),
            getTaskButton.topAnchor.constraint(equalTo: viewForEmbedding.bottomAnchor, constant: Constants.defaultSpacing * 2),
            viewForEmbedding.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.defaultSpacing * 1.5),
            viewForEmbedding.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.defaultSpacing * 1.5)
        ])
    }
}

// MARK: - View Setup
private extension LandingViewController {
    
    func setupViews() {
        view.backgroundColor = theme.colours.mainColor
        theme(getTaskButton, theme.colours.mainColor, backgroundColor: theme.colours.secondaryColor)
        
        view.addSubview(getTaskButton)
        view.addSubview(taskStoreLabel)
        view.addSubview(welcomeLabel)
        view.addSubview(settingsButton)
        view.addSubview(friendlyTipButton)
        
        presenter.addContentController(EnterTaskViewController(dependencies: dependencies))
        presenter.updateStoreDescription(0, 0)
        presenter.updateFriendlyTipButton()
        
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
            
            friendlyTipButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 2 * Constants.defaultSpacing),
            friendlyTipButton.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            friendlyTipButton.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),

            taskStoreLabel.topAnchor.constraint(equalTo: friendlyTipButton.bottomAnchor, constant: 2 * Constants.defaultSpacing),
            taskStoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.defaultSpacing),
            taskStoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.defaultSpacing),
            taskStoreLabel.bottomAnchor.constraint(lessThanOrEqualTo: getTaskButton.topAnchor, constant: -Constants.defaultSpacing),

            getTaskButton.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            getTaskButton.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            getTaskButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.defaultSpacing),
            
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

        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        return button
    }
}
