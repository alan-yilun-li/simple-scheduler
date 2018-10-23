//
//  TestViewContorller.swift
//  Simple Scheduler
//
//  Created by Alan Li on 2018-10-06.
//  Copyright © 2018 Alan Li. All rights reserved.
//

import UIKit

struct EditingTaskModel {
    
    var name: String?
    var time: Int?
    
    init(name: String? = nil, time: Int? = nil) {
        self.name = name
        self.time = time
    }
    
    var isFilled: Bool {
        return time != nil && name != nil
    }
}

protocol EnterTaskDelegate: class {
    func enterNamePressed()
    func enterNameDoneEditing()
    func enterTimePressed()
    func enterTimeDoneEditing()
    func enterDifficultyPressed()
}

extension EnterTaskDelegate {
    func enterNamePressed() {}
    func enterNameDoneEditing() {}

    func enterTimePressed() {}
    func enterTimeDoneEditing() {}

    func enterDifficultyPressed() {}
}

class EnterTaskViewController: UIViewController {
    
    private enum TaskPartTag: Int {
        case name, difficulty, time, enter
    }
    
    private struct Constants {
        static let defaultSpacing: CGFloat = 16.0
        
        static let buttonBorderWidth: CGFloat = 3.5
        static let buttonLineHeightPercentage: CGFloat = 2.0
        static let buttonWidthProportion: CGFloat = 0.75
        
        static let defaultExpectedTime: TimeInterval = 60 * 5
    }
    
    private let dependencies: AYLDependencies
    private var theme: AYLTheme {
        return dependencies.theme
    }
    
    weak var delegate: EnterTaskDelegate?
    
    var editingModel = EditingTaskModel()
    
    override var inputView: UIView? {
        let input = timePicker
        input.backgroundColor = theme.colours.mainColor
        input.tintColor = theme.colours.secondaryColor
        return input
    }
    
    override var inputAccessoryView: UIView? {
        return isFirstResponder ? timeInputDoneToolbar : nil
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = theme.fonts.small
        label.textColor = theme.colours.mainTextColor
        label.text = "📬 Enter Task"
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
        return !taskNameField.isFirstResponder
    }
    
    private lazy var pickNameButton: UIButton = {
        let button = UIButton(type: .system)
        button.tag = TaskPartTag.name.rawValue
        customizeButtonFontAndShape(button)
        button.setTitle("✏️ Task Name", for: .normal)
        button.addTarget(self, action: #selector(pickNamePressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var taskNameField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.placeholder = "Short Description Here!"
        textField.font = theme.fonts.standard
        textField.textColor = theme.colours.userEnteredText
        textField.textAlignment = .center
        textField.returnKeyType = .done
        textField.delegate = self
        return textField
    }()
    
    private lazy var pickTimeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tag = TaskPartTag.time.rawValue
        customizeButtonFontAndShape(button)
        button.setTitle("⌛ Expected Time", for: .normal)
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
        timePicker.countDownDuration = Constants.defaultExpectedTime
        return timePicker
    }()
    
    private lazy var enterTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.tag = TaskPartTag.enter.rawValue
        customizeButtonFontAndShape(button, mainButton: true)
        button.setTitle(StringStore.enterTask, for: .normal)
        button.addTarget(self, action: #selector(enterTaskPressed), for: .touchUpInside)
        return button
    }()
    
    /// Populated from `isolateTaskPart` to be able to handle any completion actions on restoration.
    private var restoreIsolatedStateHandler: (() -> Void)?
    
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
    
    @objc func pickNamePressed(_ sender: UIButton) {
        delegate?.enterNamePressed()
        
        guard let tag = TaskPartTag(rawValue: sender.tag) else {
            assertionFailure("incorrect enum setup for task part tags")
            return
        }
        isolateTaskPart(tag) { [weak self] in
            guard let `self` = self else { return }
            self.editingModel.name = self.taskNameField.text
            self.taskNameField.removeFromSuperview()
            
            if let name = self.editingModel.name, !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                self.pickNameButton.setTitle("✏️ \(name)", for: .normal)
                self.themeButton(self.pickNameButton, true)
            } else {
                self.taskNameField.text = ""
                self.pickNameButton.setTitle("✏️ Task Name", for: .normal)
                self.themeButton(self.pickNameButton, false)
            }
            self.view.endEditing(true)
            self.resignFirstResponder()
            self.delegate?.enterNameDoneEditing()
        }
        guard let nameButtonIndex = mainStackView.arrangedSubviews.firstIndex(of: pickNameButton) else {
            assertionFailure("incorrect enum setup for task part tags")
            return
        }
        mainStackView.insertArrangedSubview(taskNameField, at: nameButtonIndex + 1)
        taskNameField.becomeFirstResponder()
    }
    
    @objc func pickTimePressed(_ sender: UIButton) {
        delegate?.enterTimePressed()
        
        guard let tag = TaskPartTag(rawValue: sender.tag) else {
            assertionFailure("incorrect enum setup for task part tags")
            return
        }
        isolateTaskPart(tag) { [weak self] in
            defer {
                self?.resignFirstResponder()
                self?.delegate?.enterTimeDoneEditing()
            }
            guard let `self` = self else { return }
            
            let hours = Calendar.current.component(.hour, from: self.timePicker.date)
            let minutes = Calendar.current.component(.minute, from: self.timePicker.date)

            self.editingModel.time = (hours * 60) + minutes
            if hours == 0 {
                guard minutes != 0 else {
                    return
                }
                self.pickTimeButton.setTitle("⌛ \(minutes)mins", for: .normal)
            } else if minutes == 0 {
                self.pickTimeButton.setTitle("⌛ \(hours)hrs", for: .normal)
            } else {
                self.pickTimeButton.setTitle("⌛ \(hours)hrs \(minutes)mins", for: .normal)
            }
            self.themeButton(self.pickTimeButton, true)
        }
        self.becomeFirstResponder()
    }
    
    @objc func timeInputDidPressDone() {
        restoreStateAfterIsolation()
    }
    
    @objc func enterTaskPressed(_ sender: UIButton) {
        guard editingModel.isFilled else {
            sender.shake()
            return
        }
        let context = dependencies.persistentContainer.viewContext
        context.performChanges {
            _ = Task.insert(into: context, name: self.editingModel.name!,
                            time: Int16(clamping: self.editingModel.time!), difficulty: 0)
        }
        // Add some kind of reward message or button
        clearInputs()
    }
}

// MARK: - Dynamic View Modification
extension EnterTaskViewController {

    private func isolateTaskPart(_ taskPart: TaskPartTag, restoreStateHandler: (() -> Void)? = nil) {
        for part in mainStackView.arrangedSubviews where part.tag != taskPart.rawValue {
            part.isHidden = true
        }
        restoreIsolatedStateHandler = restoreStateHandler
    }
    
    func restoreStateAfterIsolation() {
        UIView.animate(withDuration: 0.3) {
            for view in self.mainStackView.arrangedSubviews {
                view.isHidden = false
            }
            self.restoreIsolatedStateHandler?()
        }
    }
    
    func clearInputs() {
        taskNameField.text = nil
        themeButton(pickNameButton, false)
        themeButton(pickTimeButton, false)
        pickNameButton.setTitle("✏️ Task Name", for: .normal)
        pickTimeButton.setTitle("⌛ Expected Time", for: .normal)
        timePicker.countDownDuration = Constants.defaultExpectedTime
    }
}

// MARK: - View Setup
private extension EnterTaskViewController {
    
    func setupViews() {
        view.backgroundColor = theme.colours.mainColor
        view.layer.masksToBounds = false
        
        view.layer.cornerRadius = 20
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowRadius = 10
        view.layer.shouldRasterize = true
        
        view.addSubview(titleLabel)

        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(pickNameButton)
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
    
    func customizeButtonFontAndShape(_ button: UIButton, mainButton: Bool = false) {
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
        button.layer.shadowOffset = !mainButton ? CGSize(width: 0, height: 1) : CGSize(width: 3, height: 3)

        if mainButton { button.layer.borderWidth = Constants.buttonBorderWidth }
        themeButton(button, false)
    }
}

// MARK: - UITextField Delegate
extension EnterTaskViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.restoreStateAfterIsolation()
        return true
    }
}
