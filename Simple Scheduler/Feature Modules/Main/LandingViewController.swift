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
        static let friendlyTipOpacity: Float = 0.8
    }
    
    private let dependencies: AYLDependencies
    private var theme: AYLTheme {
        return dependencies.theme
    }
    
    lazy var taskActionButton: UIButton = {
            let button = UIButton(type: .system)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle(StringStore.getTask, for: .normal)
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

            button.layer.shadowOpacity = 0.5
            button.layer.shadowOffset = CGSize(width: 3, height: 3)

            return button
    }()

    /// Enter or get task view
    private var mainContentView: UIView!
    
    lazy var containerScrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = false
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    var scrollViewBottomConstraint: NSLayoutConstraint!
    
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
        label.text = presenter.storeDescription
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
    
    private var sketchPadHeightConstraint: NSLayoutConstraint!
    private var sketchPadMainContentConstraint: NSLayoutConstraint!
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerScrollView.contentSize = view.frame.size
    }
}

extension LandingViewController {
    
    func showSketchPadView() {
        let sketchPadVC = self.presenter.sketchPadVC
        sketchPadMainContentConstraint.constant = -Constants.defaultSpacing * 2
        sketchPadHeightConstraint.isActive = false
        sketchPadVC?.view.isHidden = false
  
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            sketchPadVC?.titleLabel.layer.opacity = 1.0
        }) { _ in
        }
    }
    
    func hideSketchPadView() {
        let sketchPadVC = self.presenter.sketchPadVC
        sketchPadMainContentConstraint.constant = 0
        sketchPadHeightConstraint.isActive = true
        
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            sketchPadVC?.titleLabel.layer.opacity = 0.0
        }) { _ in
            sketchPadVC?.view.isHidden = true
        }
    }
}

// MARK: - View Setup
private extension LandingViewController {
    
    func addSketchPadVC() {
        presenter.sketchPadVC = SketchPadViewController(dependencies: dependencies)
        addChild(presenter.sketchPadVC)

        guard let sketchPadView = presenter.sketchPadVC.view else {
            assertionFailure("sketchpad view should exist")
            return
        }
        sketchPadView.translatesAutoresizingMaskIntoConstraints = false
        containerScrollView.addSubview(sketchPadView)
        
        sketchPadHeightConstraint = sketchPadView.heightAnchor.constraint(equalToConstant: 0)
        sketchPadHeightConstraint.priority = .required
        
        sketchPadMainContentConstraint = sketchPadView.bottomAnchor.constraint(equalTo: mainContentView.topAnchor, constant: -Constants.defaultSpacing * 2)
        
        NSLayoutConstraint.activate([
            sketchPadView.topAnchor.constraint(equalTo: taskStoreLabel.bottomAnchor, constant: Constants.defaultSpacing),
            sketchPadView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.defaultSpacing * 1.5),
            sketchPadView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.defaultSpacing * 1.5),
            sketchPadMainContentConstraint
        ])
        presenter.sketchPadVC.didMove(toParent: self)
    }
    
    func addTaskActionController() {
        guard let viewForEmbedding = presenter.taskActionViewController.view else {
            assertionFailure("view should exist")
            return
        }
        addChild(presenter.taskActionViewController)

        mainContentView = viewForEmbedding
        containerScrollView.addSubview(viewForEmbedding)
        viewForEmbedding.translatesAutoresizingMaskIntoConstraints = false
        viewForEmbedding.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 999), for: .vertical)
        
        
        if let sketchPadVC = presenter.sketchPadVC, sketchPadVC.view.superview != nil {
            sketchPadMainContentConstraint = sketchPadVC.view.bottomAnchor.constraint(equalTo: mainContentView.topAnchor, constant: -Constants.defaultSpacing * 2)
            sketchPadMainContentConstraint.isActive = true
        }
        
        let constraints = [
            viewForEmbedding.bottomAnchor.constraint(equalTo: taskActionButton.topAnchor, constant: -Constants.defaultSpacing * 2),
            viewForEmbedding.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.defaultSpacing * 1.5),
            viewForEmbedding.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.defaultSpacing * 1.5)
        ]
        constraints.forEach { $0.priority = UILayoutPriority(rawValue: 999) }
        NSLayoutConstraint.activate(constraints)

        presenter.taskActionViewController.didMove(toParent: self)
    }
    
    func setupViews() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: presenter, action: #selector(LandingPresenter.didPressScreen(_:))))
        
        view.backgroundColor = theme.colours.mainColor
        theme(taskActionButton, theme.colours.mainColor, backgroundColor: theme.colours.secondaryColor)
        
        view.addSubview(containerScrollView)
        
        containerScrollView.addSubview(taskActionButton)
        containerScrollView.addSubview(taskStoreLabel)
        containerScrollView.addSubview(welcomeLabel)
        containerScrollView.addSubview(settingsButton)
        containerScrollView.addSubview(friendlyTipButton)
        
        addTaskActionController()
        addSketchPadVC()
        
        presenter.updateFriendlyTipButton()
        
        settingsButton.addTarget(presenter, action: #selector(presenter.didPressSettings), for: .touchUpInside)
        taskActionButton.addTarget(presenter, action: #selector(presenter.didPressTaskAction), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(presenter, selector: #selector(LandingPresenter.keyboardWillChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        NotificationCenter.default.addObserver(presenter, selector: #selector(LandingPresenter.keyboardWillChange), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupConstraints() {
        
        let highPriorityConstraints = [
            friendlyTipButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 2 * Constants.defaultSpacing),
            taskStoreLabel.topAnchor.constraint(equalTo: friendlyTipButton.bottomAnchor, constant: 2 * Constants.defaultSpacing)
        ]
        highPriorityConstraints.forEach { $0.priority = .required }
        
        // ScrollView Constraints
        scrollViewBottomConstraint = containerScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

        NSLayoutConstraint.activate([
            containerScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            containerScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollViewBottomConstraint
        ])

        // General Constraints
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: containerScrollView.safeAreaLayoutGuide.topAnchor, constant: Constants.defaultSpacing),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.defaultSpacing),
            welcomeLabel.trailingAnchor.constraint(lessThanOrEqualTo: settingsButton.leadingAnchor, constant: -Constants.defaultSpacing),
            
            settingsButton.centerYAnchor.constraint(equalTo: welcomeLabel.centerYAnchor),
            settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.defaultSpacing),
            
            friendlyTipButton.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            friendlyTipButton.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),

            taskStoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.defaultSpacing),
            taskStoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.defaultSpacing),
            taskStoreLabel.bottomAnchor.constraint(lessThanOrEqualTo: taskActionButton.topAnchor, constant: -Constants.defaultSpacing),

            taskActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.defaultSpacing * 2.5),
            taskActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.defaultSpacing * 2.5),
            taskActionButton.bottomAnchor.constraint(equalTo: containerScrollView.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.defaultSpacing)
        ] + highPriorityConstraints)
    }
    
    func theme(_ button: UIButton, _ textColor: UIColor, backgroundColor: UIColor, withBorder: Bool = false) {
        if withBorder {
            button.layer.borderColor = textColor.cgColor
            button.layer.borderWidth = Constants.buttonBorderWidth
        } else {
            button.layer.borderColor = nil
            button.layer.borderWidth = 0
        }
        button.backgroundColor = backgroundColor
        button.setTitleColor(textColor, for: .normal)
    }
}
