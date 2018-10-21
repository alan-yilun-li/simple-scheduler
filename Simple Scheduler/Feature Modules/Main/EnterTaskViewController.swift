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
        
        static let buttonBorderWidth: CGFloat = 2.0
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
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = theme.fonts.small
        label.textColor = theme.colours.mainTextColor
        label.text = "✏️ Enter Task"
        return label
    }()
    
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Constants.defaultSpacing
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    private lazy var pickTimeButton: UIButton = {
        let button = UIButton(type: .system)
        customizeButtonFontAndShape(button)

        button.setTitle("⌛ Expected Time", for: .normal)

        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.addTarget(self, action: #selector(pickTimePressed), for: .touchUpInside)
        
        themeButton(button, false)
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
        customizeButtonFontAndShape(button)
        
        button.setTitle(StringStore.enterTask, for: .normal)
        button.layer.borderWidth = Constants.buttonBorderWidth
        
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        button.addTarget(self, action: #selector(enterTaskPressed), for: .touchUpInside)
        themeButton(button, false)
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
        
        view.addSubview(titleLabel)

        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(pickTimeButton)
        mainStackView.addArrangedSubview(enterTaskButton)
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.defaultSpacing),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            mainStackView.topAnchor.constraint(lessThanOrEqualTo: titleLabel.bottomAnchor, constant: Constants.defaultSpacing),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.defaultSpacing),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.defaultSpacing),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.defaultSpacing)
        ])
    }
    
    func themeButton(_ button: UIButton, _ filled: Bool) {
        if filled {
            button.setTitleColor(theme.colours.mainColor, for: .normal)
            button.backgroundColor = theme.colours.secondaryColor
        } else {
            button.setTitleColor(theme.colours.secondaryColor, for: .normal)
            button.backgroundColor = theme.colours.mainColor
        }
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
    }
}
