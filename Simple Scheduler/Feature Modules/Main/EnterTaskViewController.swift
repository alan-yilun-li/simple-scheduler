//
//  TestViewContorller.swift
//  Simple Scheduler
//
//  Created by Alan Li on 2018-10-06.
//  Copyright © 2018 Alan Li. All rights reserved.
//

import UIKit

class EnterTaskViewController: UIViewController {
    
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
    
    override var inputView: UIView? {
        let input = timePicker
        input.backgroundColor = theme.colours.mainColor
        input.tintColor = theme.colours.secondaryColor
        return input
    }
    
    override var inputAccessoryView: UIView? {
        return timeInputDoneToolbar
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    private lazy var pickTimeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("⌛ Set Time", for: .normal)
        button.setTitleColor(theme.colours.mainColor, for: .normal)
        button.titleLabel?.font = theme.fonts.standard
        button.backgroundColor = theme.colours.secondaryColor
        
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
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.addTarget(self, action: #selector(pickTimePressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var timeInputDoneToolbar: UIToolbar = {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .blackOpaque
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(timeInputDidPressDone))
        doneButton.tintColor = theme.colours.mainColor
        
        let items = [flexSpace, doneButton]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        return doneToolbar
    }()

    
    private lazy var timePicker: UIDatePicker = {
        let timePicker = UIDatePicker(frame: .zero)
        timePicker.datePickerMode = .countDownTimer
        timePicker.minuteInterval = 5
        
        return timePicker
    }()
    
    private lazy var enterTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle(StringStore.enterTask, for: .normal)
        button.setTitleColor(theme.colours.mainTextColor, for: .normal)
        button.titleLabel?.font = theme.fonts.standard
        
        button.backgroundColor = theme.colours.mainColor
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
        
        button.addTarget(self, action: #selector(enterTaskPressed), for: .touchUpInside)
        
        return button
    }()
    
    init(dependencies: AYLDependencies) {
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

// MARK: - Actions
extension EnterTaskViewController {
    
    @objc func pickTimePressed() {
        self.becomeFirstResponder()
    }
    
    @objc func timeInputDidPressDone() {
        // Capture time here
        self.resignFirstResponder()
    }
    
    @objc func enterTaskPressed() {
        enterTaskButton.shake(withFlash: true)
    }
}

// MARK: - View Setup
private extension EnterTaskViewController {
    
    func setupViews() {
        
        view.backgroundColor = UIColor.white
        view.layer.masksToBounds = false
        
        view.layer.cornerRadius = 20
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowRadius = 10
        view.layer.shouldRasterize = true

        view.addSubview(enterTaskButton)
//        view.addSubview(difficultyControl)
        view.addSubview(pickTimeButton)
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            pickTimeButton.bottomAnchor.constraint(equalTo: enterTaskButton.topAnchor, constant: -Constants.defaultSpacing),
            pickTimeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.defaultSpacing),
            pickTimeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.defaultSpacing),
            
            enterTaskButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                 constant: -Constants.defaultSpacing),

            enterTaskButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.defaultSpacing),
            enterTaskButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.defaultSpacing)
        ])
    }
}
