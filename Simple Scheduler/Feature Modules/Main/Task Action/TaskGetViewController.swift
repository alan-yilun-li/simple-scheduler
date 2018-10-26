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
        
        static let buttonBorderWidth: CGFloat = 3.5
        static let buttonLineHeightPercentage: CGFloat = 2.0
        static let buttonWidthProportion: CGFloat = 0.75
    }
    
    private let dependencies: AYLDependencies
    private var theme: AYLTheme {
        return dependencies.theme
    }
    
    private let task: Task
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = theme.fonts.small
        label.textColor = theme.colours.mainTextColor
        label.text = "⛰️ Your Task"
        return label
    }()
    
    private lazy var nameHeader: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = theme.fonts.smallItalicized
        label.textColor = theme.colours.mainGrey
        label.text = "🔥 Name"
        return label
    }()
    
    private lazy var timeHeader: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = theme.fonts.smallItalicized
        label.textColor = theme.colours.mainGrey
        label.text = "⏰ Expected Time"
        return label
    }()
    
    private lazy var taskNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = theme.fonts.standard
        label.textColor = theme.colours.mainTextColor
        label.text = task.name
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var taskTimeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = theme.fonts.standard
        label.textColor = theme.colours.mainTextColor
        label.text = "\(task.time / 60)hrs \(task.time % 60)mins"
        return label
    }()
    
    private lazy var stopWatchHeader: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = theme.fonts.smallItalicized
        label.textColor = theme.colours.mainGrey
        label.text = "Time Elapsed"
        return label
    }()
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = theme.fonts.mainTitle
        label.textColor = theme.colours.mainTextColor
        label.text = "00:00:00"
        return label
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        customizeButtonFontAndShape(button)
        themeButton(button, filled: false, withBorder: true)
        button.setTitle("Cancel", for: .normal)
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        customizeButtonFontAndShape(button)
        themeButton(button, filled: true)
        button.setTitle("Complete", for: .normal)
        button.addTarget(self, action: #selector(completeButtonPressed), for: .touchUpInside)
        return button
    }()

    var timer: Timer!
    var secondsElapsed: Int = 0
    
    init(dependencies: AYLDependencies, task: Task) {
        self.dependencies = dependencies
        self.task = task
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeIntervalDidPass), userInfo: nil, repeats: true)
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
    
    @objc func timeIntervalDidPass() {
        secondsElapsed += 1
        
        let hours = secondsElapsed / 3600
        let minutes = secondsElapsed / 60 % 60
        let seconds = secondsElapsed % 60
        
        timerLabel.text = String(format: "%02i:%02i:%02i", hours, minutes, seconds)
        
        if secondsElapsed  == task.time * 60 {
            timer.invalidate()
        }
    }
    
    @objc func cancelButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func completeButtonPressed() {
        let context = dependencies.persistentContainer.viewContext
        context.performChanges {
            context.delete(self.task)
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - View Setup
extension TaskGetViewController {
    
    func themeButton(_ button: UIButton, filled: Bool, withBorder: Bool = false) {
        if filled {
            button.setTitleColor(theme.colours.mainColor, for: .normal)
            button.backgroundColor = theme.colours.secondaryColor
        } else {
            button.setTitleColor(theme.colours.secondaryColor, for: .normal)
            button.backgroundColor = theme.colours.mainColor
        }
        
        button.layer.borderWidth = withBorder ? Constants.buttonBorderWidth : 0
    }
    
    func customizeButtonFontAndShape(_ button: UIButton) {
        button.titleLabel?.font = theme.fonts.standard
        
        guard let lineHeight = button.titleLabel?.font.lineHeight else {
            assertionFailure("titlelabel of button doesn't exist")
            return
        }
        let buttonHeight = lineHeight * Constants.buttonLineHeightPercentage
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: buttonHeight),
            ])
        button.layer.cornerRadius = buttonHeight / 2
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(taskNameLabel)
        view.addSubview(taskTimeLabel)
        view.addSubview(nameHeader)
        view.addSubview(timeHeader)
        
        view.addSubview(stopWatchHeader)
        view.addSubview(timerLabel)
        
        view.addSubview(cancelButton)
        view.addSubview(completeButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.defaultSpacing),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameHeader.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.defaultSpacing / 2),
            nameHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.defaultSpacing * 2),
            
            taskNameLabel.topAnchor.constraint(equalTo: nameHeader.bottomAnchor, constant: Constants.defaultSpacing / 4),
            taskNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.defaultSpacing * 2),
            taskNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.defaultSpacing),

            timeHeader.topAnchor.constraint(equalTo: taskNameLabel.bottomAnchor, constant: Constants.defaultSpacing),
            timeHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.defaultSpacing * 2),

            taskTimeLabel.topAnchor.constraint(equalTo: timeHeader.bottomAnchor, constant: Constants.defaultSpacing / 4),
            taskTimeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.defaultSpacing * 2),
            taskTimeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.defaultSpacing),
            
            stopWatchHeader.topAnchor.constraint(equalTo: taskTimeLabel.bottomAnchor, constant: Constants.defaultSpacing),
            stopWatchHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.defaultSpacing * 2),
            timerLabel.topAnchor.constraint(equalTo: stopWatchHeader.bottomAnchor, constant: Constants.defaultSpacing / 4),
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            cancelButton.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: Constants.defaultSpacing),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.defaultSpacing),
            cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.defaultSpacing),
            
            completeButton.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor),
            completeButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
            completeButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: Constants.defaultSpacing),
            completeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.defaultSpacing)
        ])
    }
}
