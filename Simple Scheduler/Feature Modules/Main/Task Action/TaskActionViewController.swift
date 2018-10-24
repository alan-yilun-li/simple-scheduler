//
//  TestViewContorller.swift
//  Simple Scheduler
//
//  Created by Alan Li on 2018-10-06.
//  Copyright © 2018 Alan Li. All rights reserved.
//

import UIKit

protocol TaskActionDelegate: class {
    func enterNamePressed()
    func enterNameDoneEditing()
    func enterTimePressed()
    func enterTimeDoneEditing()
    func enterDifficultyPressed()
    func enterDifficultyDoneEditing()

    func taskActionButtonPressed()
}

extension TaskActionDelegate {
    func enterNamePressed() {}
    func enterNameDoneEditing() {}

    func enterTimePressed() {}
    func enterTimeDoneEditing() {}

    func enterDifficultyPressed() {}
    func enterDifficultyDoneEditing() {}
}

class TaskActionViewController: UIViewController {
    
    private enum TaskPartTag: Int {
        case name, difficulty, time, action
    }
    
    private struct Constants {
        static let defaultSpacing: CGFloat = 16.0
        
        static let buttonBorderWidth: CGFloat = 3.5
        static let buttonLineHeightPercentage: CGFloat = 2.0
        static let buttonWidthProportion: CGFloat = 0.75
        
        static let defaultExpectedTime: TimeInterval = 60 * 5
    }
    
    var tasks = [Task]()
    var mode: TaskActionPresentationObject.Mode {
        get { return presentationObject.mode }
        set { presentationObject.mode = newValue }
    }
    
    fileprivate lazy var presentationObject = TaskActionPresentationObject(mode: .enter, delegate: self)
    
    private let dependencies: AYLDependencies
    private var theme: AYLTheme {
        return dependencies.theme
    }
    
    weak var delegate: TaskActionDelegate?
    
    var editingModel = EditTaskModel()
    
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
        label.text = presentationObject.titleText
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
        button.setTitle(presentationObject.editTimeText, for: .normal)
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
    
    private lazy var taskActionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tag = TaskPartTag.action.rawValue
        customizeButtonFontAndShape(button, isMainButton: true)
        button.setTitle(presentationObject.actionText, for: .normal)
        button.addTarget(self, action: #selector(taskActionPressed), for: .touchUpInside)
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
extension TaskActionViewController {
    
    @objc func pickNamePressed(_ sender: UIButton) {
        delegate?.enterNamePressed()
        
        guard let tag = TaskPartTag(rawValue: sender.tag) else {
            assertionFailure("incorrect enum setup for task part tags")
            return
        }
        isolateTaskPart(tag) { [weak self] in
            guard let `self` = self else { return }
            self.taskNameField.removeFromSuperview()

            self.setName(self.taskNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines))

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

            self.setTime(hours, minutes: minutes)
        }
        self.becomeFirstResponder()
    }
    
    @objc func timeInputDidPressDone() {
        restoreStateAfterIsolation()
    }
    
    @objc func taskActionPressed(_ sender: UIButton) {
        switch mode {
        case .enter:
            guard editingModel.isFilled(true) else {
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
        case .get:
            guard editingModel.isFilled(false) else {
                sender.shake()
                return
            }
            return
            
            
        }
    }
}

// MARK: - Dynamic View Modification
extension TaskActionViewController {

    private func isolateTaskPart(_ taskPart: TaskPartTag, restoreStateHandler: (() -> Void)? = nil) {
        for part in mainStackView.arrangedSubviews where part.tag != taskPart.rawValue {
            part.isHidden = true
        }
        restoreIsolatedStateHandler = restoreStateHandler
    }
    
    func restoreStateAfterIsolation() {
        UIView.animate(withDuration: 0.3) {
            for view in self.mainStackView.arrangedSubviews {
                guard self.mode == .enter || view !== self.pickNameButton else { continue }
                view.isHidden = false
            }
            self.restoreIsolatedStateHandler?()
        }
    }
    
    func clearInputs() {
        taskNameField.text = nil
        themeButton(pickNameButton, filled: false)
        themeButton(pickTimeButton, filled: false)
        pickTimeButton.setTitle(presentationObject.editTimeText, for: .normal)
        pickNameButton.setTitle("✏️ Task Name", for: .normal)
        timePicker.countDownDuration = Constants.defaultExpectedTime
    }
}

// MARK: - View Setup
private extension TaskActionViewController {
    
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
        mainStackView.addArrangedSubview(taskActionButton)
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
    
    func customizeButtonFontAndShape(_ button: UIButton, isMainButton: Bool = false) {
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
        button.layer.shadowOffset = !isMainButton ? CGSize(width: 0, height: 1) : CGSize(width: 3, height: 3)

        themeButton(button, filled: false, withBorder: isMainButton)
    }
}

// MARK: - UITextField Delegate
extension TaskActionViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.restoreStateAfterIsolation()
        return true
    }
}

// MARK: - PresentationObject Delegate
extension TaskActionViewController: PresentationObjectDelegate {
    func modeDidChange(_ presentationObject: TaskActionPresentationObject) {
        switch presentationObject.mode {
        case .enter:
            UIView.animate(withDuration: 0.3) {
                self.pickNameButton.isHidden = false
            }
        case .get:
            self.pickNameButton.isHidden = true
        }
        UIView.animate(withDuration: 0.3) {
            self.clearInputs()
            self.titleLabel.text = presentationObject.titleText
            self.taskActionButton.setTitle(presentationObject.actionText, for: .normal)
        }
    }
}

// MARK: - Editing Model setting
extension TaskActionViewController: EditTaskModelDelegate {

    func editTaskModelDidChange(_ editTaskModel: EditTaskModel) {
        let isFilled = editTaskModel.isFilled(mode == .enter)
        themeButton(taskActionButton, filled: isFilled, withBorder: !isFilled)
    }

    func setTime(_ hours: Int, minutes: Int) {
        self.editingModel.time = (hours * 60) + minutes
        if hours == 0 {
            guard minutes != 0 else {
                self.themeButton(self.pickTimeButton, filled: false)
                return
            }
            self.pickTimeButton.setTitle("⌛ \(minutes)mins", for: .normal)
        } else if minutes == 0 {
            self.pickTimeButton.setTitle("⌛ \(hours)hrs", for: .normal)
        } else {
            self.pickTimeButton.setTitle("⌛ \(hours)hrs \(minutes)mins", for: .normal)
        }
        self.themeButton(self.pickTimeButton, filled: true)
    }

    func setName(_ name: String?) {
        self.editingModel.name = name
        if let name = self.editingModel.name, !name.isEmpty {
            self.pickNameButton.setTitle("✏️ \(name)", for: .normal)
            self.themeButton(self.pickNameButton, filled: true)
        } else {
            self.taskNameField.text = ""
            self.pickNameButton.setTitle("✏️ Task Name", for: .normal)
            self.themeButton(self.pickNameButton, filled: false)
        }
    }
}
